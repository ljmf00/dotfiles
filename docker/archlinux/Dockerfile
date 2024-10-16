# syntax=docker/dockerfile:1.4

ARG BUILDPLATFORM=$BUILDPLATFORM
ARG BUILDOS=$BUILDOS
ARG BUILDARCH=$BUILDARCH
ARG BUILDVARIANT=$BUILDVARIANT

ARG TARGETPLATFORM=$TARGETPLATFORM
ARG TARGETOS=$TARGETOS
ARG TARGETARCH=$TARGETARCH
ARG TARGETVARIANT=$TARGETVARIANT

# hadolint ignore=DL3007
FROM --platform=$BUILDPLATFORM public.ecr.aws/docker/library/busybox:latest AS fhs-stage0

# Bootstrap filesystem rootfs
RUN --network=none                                                       : && \
    mkdir -m 0755 /rootfs/                                                 && \
    mkdir -m 0755 /rootfs/var                                              && \
    mkdir -m 0755 /rootfs/var/log                                          && \
    mkdir -m 0755 /rootfs/var/empty                                        && \
    mkdir -m 0755 /rootfs/var/db                                           && \
    mkdir -m 0755 /rootfs/var/opt                                          && \
    mkdir -m 1777 /rootfs/var/tmp                                          && \
    mkdir -m 0755 /rootfs/var/local                                        && \
    mkdir -m 0755 /rootfs/var/lib                                          && \
    mkdir -m 0755 /rootfs/var/cache                                        && \
    mkdir -m 0755 /rootfs/var/spool                                        && \
    mkdir -m 0755 /rootfs/var/spool/mail                                   && \
    ln -s ../run /rootfs/var/run                                           && \
    ln -s spool/mail /rootfs/var/mail                                      && \
    ln -s ../run/lock /rootfs/var/lock                                     && \
    mkdir -m 0755 /rootfs/usr                                              && \
    mkdir -m 0755 /rootfs/usr/bin                                          && \
    ln -s bin /rootfs/usr/sbin                                             && \
    mkdir -m 0755 /rootfs/usr/lib                                          && \
    mkdir -m 0755 /rootfs/usr/local                                        && \
    mkdir -m 0755 /rootfs/usr/local/etc                                    && \
    mkdir -m 0755 /rootfs/usr/local/bin                                    && \
    mkdir -m 0755 /rootfs/usr/local/share                                  && \
    mkdir -m 0755 /rootfs/usr/local/include                                && \
    mkdir -m 0755 /rootfs/usr/local/src                                    && \
    mkdir -m 0755 /rootfs/usr/share                                        && \
    mkdir -m 0755 /rootfs/usr/include                                      && \
    mkdir -m 0755 /rootfs/usr/src                                          && \
    ln -s usr/bin /rootfs/bin                                              && \
    ln -s usr/bin /rootfs/sbin                                             && \
    ln -s usr/lib /rootfs/lib                                              && \
    mkdir -m 0755 /rootfs/etc                                              && \
    ln -s ../proc/self/mounts /rootfs/etc/mtab                             && \
    mkdir -m 0755 /rootfs/dev                                              && \
    mkdir -m 0755 /rootfs/run                                              && \
    mkdir -m 0755 /rootfs/boot                                             && \
    mkdir -m 0755 /rootfs/run/lock                                         && \
    mkdir -m 1777 /rootfs/tmp                                              && \
    mkdir -m 0555 /rootfs/sys                                              && \
    mkdir -m 0555 /rootfs/proc                                             && \
    mkdir -m 0700 /rootfs/root                                             && \
    :

FROM --platform=$TARGETPLATFORM scratch AS fhs

COPY --from=fhs-stage0 /rootfs/ /

# -----------------------------------------------------------------------------
# PLATFORM STAGE: AMD64 (x86_64)
# -----------------------------------------------------------------------------
# hadolint ignore=DL3007
FROM --platform=linux/amd64 registry.archlinux.org/archlinux/archlinux-docker:base-master AS bootstrap-archlinux-amd64

# Init keyring and update
RUN pacman-key --init && \
    pacman-key --populate archlinux

# Copy custom configs
# hadolint ignore=DL3021
COPY --link ./amd64/pacman.conf /etc/pacman.conf
# hadolint ignore=DL3021
COPY --link ./amd64/makepkg.conf /etc/makepkg.conf

# -----------------------------------------------------------------------------
# PLATFORM STAGE: ARM/v7 (armv7)
# -----------------------------------------------------------------------------
# hadolint ignore=DL3007
FROM --platform=$BUILDPLATFORM public.ecr.aws/docker/library/alpine:latest AS bootstrap0-archlinux-armv7

# Install curl bash and update CA certificates
# hadolint ignore=DL3018
RUN apk add --no-cache wget bash tar ca-certificates \
  && update-ca-certificates

RUN wget --progress=dot:giga --prefer-family=IPv4 \
        --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" \
        http://os.archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz && \
    mkdir -p /rootfs && \
    tar -v -C /rootfs --extract --file "ArchLinuxARM-armv7-latest.tar.gz"

FROM --platform=linux/arm/v7 scratch AS bootstrap-archlinux-armv7
COPY --from=bootstrap0-archlinux-armv7 /rootfs/ /

RUN --network=none ln -sf ../proc/self/mounts /etc/mtab

# Init keyring and update
RUN pacman-key --init && \
    pacman-key --populate archlinuxarm

# Remove linux package
RUN pacman -Rscun linux-armv7 linux-firmware --noconfirm --noprogressbar

# Remove boot leftovers
# hadolint ignore=SC2115
RUN rm -rf /boot/*

# -----------------------------------------------------------------------------
# PLATFORM STAGE: ARM64/v8 (aarch64)
# -----------------------------------------------------------------------------
# hadolint ignore=DL3007
FROM --platform=$BUILDPLATFORM public.ecr.aws/docker/library/alpine:latest AS bootstrap0-archlinux-arm64

# Install curl bash and update CA certificates
# hadolint ignore=DL3018
RUN apk add --no-cache wget bash tar ca-certificates \
  && update-ca-certificates

RUN wget --progress=dot:giga --prefer-family=IPv4 \
        --user-agent="Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:52.0) Gecko/20100101 Firefox/52.0" \
        http://os.archlinuxarm.org/os/ArchLinuxARM-aarch64-latest.tar.gz && \
    mkdir -p /rootfs && \
    tar -v -C /rootfs --extract --file "ArchLinuxARM-aarch64-latest.tar.gz"

FROM --platform=linux/arm64 scratch AS bootstrap-archlinux-arm64
COPY --from=bootstrap0-archlinux-arm64 /rootfs/ /

RUN --network=none ln -sf ../proc/self/mounts /etc/mtab

# Init keyring and update
RUN pacman-key --init && \
    pacman-key --populate archlinuxarm

# Remove linux package
RUN pacman -Rscun linux-aarch64 linux-firmware --noconfirm --noprogressbar

# Remove boot leftovers
# hadolint ignore=SC2115
RUN rm -rf /boot/*

# -----------------------------------------------------------------------------
# BUILDER BOOTSTRAP
# -----------------------------------------------------------------------------
# hadolint ignore=DL3006
FROM --platform=$BUILDPLATFORM bootstrap-archlinux-${BUILDARCH}${BUILDVARIANT} AS bootstrap-archlinux-builder

RUN --network=none ln -sf ../proc/self/mounts /etc/mtab

# Update and install build tools
RUN pacman -Syyu base base-devel pacman-contrib devtools --noprogressbar --needed --noconfirm

# -----------------------------------------------------------------------------
# PLATFORM STAGE: i386 (x86) (After build platform bootstrap stage)
# -----------------------------------------------------------------------------
FROM --platform=$BUILDPLATFORM bootstrap-archlinux-builder AS bootstrap0-archlinux-386

ENV PACMAN_MIRRORLIST 'Server = https://mirror.archlinux32.org/$arch/$repo'

# hadolint ignore=DL3021
COPY --link ./generic/pacman-nosig.conf /etc/pacman.conf
RUN echo "$PACMAN_MIRRORLIST" > /etc/pacman.d/mirrorlist

RUN mkdir -m 0755 /rootfs/
COPY --from=fhs / /rootfs/

# Bootstrap needed pacman folders
RUN --network=none                                                       : && \
    mkdir -m 0755 /rootfs/var/cache/pacman                                 && \
    mkdir -m 0755 /rootfs/var/cache/pacman/pkg                             && \
    mkdir -m 0755 /rootfs/var/lib/pacman                                   && \
    :

RUN pacman -r /rootfs --arch i686                                             \
    -Sy --noconfirm --noprogressbar --overwrite '*' base archlinux32-keyring

COPY --link ./i686/pacman.conf /rootfs/etc/pacman.conf
RUN echo "$PACMAN_MIRRORLIST" > /rootfs/etc/pacman.d/mirrorlist

FROM --platform=linux/386 scratch AS bootstrap-archlinux-386
COPY --from=bootstrap0-archlinux-386 /rootfs/ /

# Init keyring and update
RUN pacman-key --init && \
    curl -Ss 'https://archlinux32.org/keys.php?k=5FDCA472AB93292BC678FD59255A76DB9A12601A' | gpg --homedir /etc/pacman.d/gnupg/ --import && \
    curl -Ss 'https://archlinux32.org/keys.php?k=16194A82231E9EF823562181C8E8F5A0AF9BA7E7' | gpg --homedir /etc/pacman.d/gnupg/ --import && \
    pacman-key --populate && \
    pacman-key --refresh

# -----------------------------------------------------------------------------
# BOOTSTRAP
# -----------------------------------------------------------------------------
# hadolint ignore=DL3006
FROM --platform=$TARGETPLATFORM bootstrap-archlinux-${TARGETARCH}${TARGETVARIANT} AS bootstrap-archlinux

RUN --network=none ln -sf ../proc/self/mounts /etc/mtab

# Remove unecessary packages
# hadolint ignore=SC2086
RUN --network=none pacman -D --asdeps $(pacman -Qq) && \
                   pacman -D --asexplicit base && \
                   (unused_pkgs="$(pacman -Qqdt)"; \
                   if [ "$unused_pkgs" != "" ]; then \
                       pacman -Rcsun $unused_pkgs --noconfirm --noprogressbar ; \
                   fi )

# Update
RUN pacman -Syyu --noprogressbar --needed --noconfirm

# -----------------------------------------------------------------------------
# BASE
# -----------------------------------------------------------------------------
# hadolint ignore=DL3006
FROM --platform=$TARGETPLATFORM bootstrap-archlinux AS base-stage0

# Set default shell
SHELL [ "/bin/sh", "-c" ]
ENV SHELL=/bin/sh

# Install sudo
RUN pacman -Syyu sudo --noprogressbar --needed --noconfirm

# Add user, group wheel, setup sudoers, set correct locale and fix PAM session permissions
# hadolint ignore=SC2039
RUN --network=none /usr/sbin/useradd -m -G wheel -g users docker && \
                   /usr/sbin/echo -e "Defaults secure_path=\"/usr/local/sbin:/usr/local/bin:/usr/bin\"\n$(/usr/sbin/cat /etc/sudoers)" > /etc/sudoers && \
                   /usr/sbin/sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
                   /usr/sbin/echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99-wheel-group && \
                   /usr/sbin/echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
                   /usr/sbin/echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
                   /usr/sbin/echo "LANG=en_US.UTF-8" > /etc/locale.conf && \
                   /usr/sbin/locale-gen en_US.UTF-8 && \
                   /usr/sbin/sed -i 's/^\(session.*\)required\(.*pam_limits.so\)/\1optional\2/' /etc/pam.d/system-auth

# Set locale env
ENV LC_CTYPE 'en_US.UTF-8'

# hadolint ignore=DL3021
COPY --link ./generic/00-opt-session-pam.hook /etc/pacman.d/hooks/00-opt-session-pam.hook
COPY --link ./generic/00-package-cleanup.hook /etc/pacman.d/hooks/00-package-cleanup.hook

# Remove unrequired dependencies
# hadolint ignore=SC2086
RUN --network=none pacman -D --asdeps $(pacman -Qq) && \
                   pacman -D --asexplicit base sudo && \
                   (unused_pkgs="$(pacman -Qqdt)"; \
                   if [ "$unused_pkgs" != "" ]; then \
                       pacman -Rcsun $unused_pkgs --noconfirm --noprogressbar ; \
                   fi )

RUN pacman -Syyu --asexplicit base sudo --noprogressbar --noconfirm --overwrite '*'

# update trusted certs
RUN /usr/sbin/trust extract-compat && \
    /usr/sbin/update-ca-trust

# alias for FROM dependencies
FROM base-stage0 AS from-base

# -----------------------------------------------------------------------------
# LITE
# -----------------------------------------------------------------------------
FROM --platform=$TARGETPLATFORM public.ecr.aws/docker/library/alpine:edge AS lite-stage0

# Install pacman and busybox and then remove all alpine leftovers
# hadolint ignore=DL3018
RUN apk add --no-cache pacman busybox && \
    apk del alpine-keys alpine-baselayout apk-tools && \
    rm -rf /etc/apk* /lib/apk* && \
    rm -rf /etc/alpine-release && \
    rm -rf /etc/secfixes.d/alpine && \
    rm -rf /etc/os-release && \
    :

RUN mkdir -m 0755 /rootfs/
COPY --from=fhs / /rootfs/

# Bootstrap needed pacman folders
RUN --network=none                                                       : && \
    mkdir -m 0755 /rootfs/var/cache/pacman                                 && \
    mkdir -m 0755 /rootfs/var/cache/pacman/pkg                             && \
    mkdir -m 0755 /rootfs/var/lib/pacman                                   && \
    :

# Copy alpine dependencies and fake an archlinux pacstrap
RUN --network=none                                                       : && \
    cp -ar /usr/bin/* /rootfs/usr/bin                                      && \
    cp -ar /usr/lib/* /rootfs/usr/lib                                      && \
    cp -ar /usr/share/* /rootfs/usr/share                                  && \
    cp -ar /bin/* /rootfs/usr/bin                                          && \
    cp -ar /lib/* /rootfs/usr/lib                                          && \
    cp -ar /etc/* /rootfs/etc                                              && \
    :

FROM --platform=$TARGETPLATFORM scratch AS lite-stage1

COPY --from=lite-stage0 /rootfs/ /

# Substitute with busybox
SHELL [ "/usr/bin/busybox", "sh",  "-c" ]

RUN --network=none /usr/bin/busybox --install

# Copy necessary files from base archlinux container
COPY --link --from=from-base /etc/arch-release /etc/arch-release
COPY --link --from=from-base /usr/lib/os-release /usr/lib/os-release
COPY --link --from=from-base /etc/makepkg.conf /etc/makepkg.conf
COPY --link --from=from-base /etc/pacman.conf /etc/pacman.conf
COPY --link --from=from-base /etc/pacman.d/ /etc/pacman.d/

RUN --network=none ln -s ../usr/lib/os-release /etc/os-release

# alias for FROM dependencies
FROM lite-stage1 AS from-lite

# -----------------------------------------------------------------------------
# DEVEL
# -----------------------------------------------------------------------------
FROM from-base AS devel-stage0

# Install base-devel and multilib-devel
RUN                                                                      : && \
    pacman -Syyu base-devel git --noprogressbar --needed --noconfirm       && \
    ([ "$TARGETARCH" = "amd64" ]                                              \
        && pacman -S multilib-devel --noprogressbar --needed --noconfirm      \
        || :                                                                  \
    )                                                                      && \
    :

# alias for FROM dependencies
FROM devel-stage0 AS from-devel

# -----------------------------------------------------------------------------
# AUR
# -----------------------------------------------------------------------------
FROM from-devel AS aur-stage0

# Install yay
# hadolint ignore=DL3004,DL3003
RUN                                                                      : && \
    pacman -Syyu --noprogressbar --noconfirm                               && \
    cd /tmp                                                                && \
    git clone https://aur.archlinux.org/yay.git                            && \
    git clone https://aur.archlinux.org/yay-bin.git                        && \
    chown -R docker:wheel yay yay-bin                                      && \
    ( (cd yay && sudo -u docker makepkg -sic --noprogressbar --noconfirm)  || \
     (cd yay-bin                                                           && \
      sudo -u docker makepkg -sic --noprogressbar --noconfirm) )           && \
    rm -rf yay yay-bin                                                     && \
    :

# alias for FROM dependencies
FROM aur-stage0 AS from-aur

# -----------------------------------------------------------------------------
# CLEANUP STAGES
# -----------------------------------------------------------------------------

FROM from-base AS base
COPY --link ./generic/cleanup /cleanup
RUN --network=none /cleanup && rm -rf /cleanup

FROM from-lite AS lite
COPY --link ./generic/cleanup /cleanup
RUN --network=none /cleanup && rm -rf /cleanup

FROM from-aur AS aur
COPY --link ./generic/cleanup /cleanup
RUN --network=none /cleanup && rm -rf /cleanup

FROM from-devel AS devel
COPY --link ./generic/cleanup /cleanup
RUN --network=none /cleanup && rm -rf /cleanup

# -----------------------------------------------------------------------------
# SQUASH STAGES
# -----------------------------------------------------------------------------

# Remove docker layers with multi-stage build
FROM scratch AS squash-stage

# set maintainer label
LABEL maintainer="Luís Ferreira <contact at lsferreira dot net>"

# Set common env vars
ENV LC_CTYPE 'en_US.UTF-8'
ENV LANG 'en_US.UTF-8'
ENV SHELL=/bin/sh

# Set default shell
SHELL [ "/bin/sh", "-c" ]

# Set workdir as /
WORKDIR /

FROM squash-stage AS lite-squash
COPY --from=lite / /

FROM squash-stage AS devel-squash
COPY --from=devel / /

FROM squash-stage AS aur-squash
COPY --from=aur / /

FROM squash-stage AS base-squash
COPY --from=base / /
