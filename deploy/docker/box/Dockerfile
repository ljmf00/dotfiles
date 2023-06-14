# syntax=docker/dockerfile:1.4
FROM ghcr.io/ljmf00/archlinux:aur AS stage0

# Init keyring
RUN pacman-key --init && \
    pacman-key --populate

# Install base-devel, git and lib32- libs for gcc runtime and glibc
RUN pacman -Syyu --noprogressbar --noconfirm                                  \
        base-devel multilib-devel git lib32-gcc-libs lib32-glibc openssh      \
        python rsync ansible bind-tools xdg-utils sudo supervisor stow

# Add user
RUN --network=none                                    : && \
    /usr/sbin/usermod -u 1001 docker                    && \
    /usr/sbin/useradd -u 1000 -m -G wheel -g users luis && \
    /usr/sbin/useradd supervisord                       && \
    passwd -d docker                                    && \
    passwd -d luis                                      && \
    passwd -d supervisord                               && \
                                                           :

WORKDIR /home/luis/

# Use bash shell
SHELL [ "/usr/bin/bash", "-c" ]
ENV SHELL=/usr/bin/bash

# Give user permissions to use ping binary
RUN chmod 4755 /usr/bin/ping

# Unset password to allow reset it
# hadolint ignore=DL3059
RUN passwd -d luis

# Copy current context to dotfiles folder
# hadolint ignore=DL3059
RUN mkdir -p  /home/luis/dotfiles/
COPY --link . /home/luis/dotfiles/
COPY ./deploy/.gitconfig /home/luis/dotfiles/.git/config

RUN chown -R luis:wheel /home/luis/

# Run dotfiles, deploy ansible locally and clean dotfiles git repo
# hadolint ignore=DL3003,DL3004,SC2164
RUN : \
    && (cd dotfiles/deploy/ansible; \
        ansible-playbook playbooks/setup-box.yml --inventory-file box_hosts; \
        ) \
    && echo "mybox" > /etc/hostname \
    && sudo -u luis bash -c 'rm -rf ~/.bash*' \
    && sudo -u luis bash -c './dotfiles/configure' \
    && (cd dotfiles; \
        rm -rf private/; \
        rm -rf .git/modules/private/; \
        rm -rf .git/objects/*; \
        sudo -u luis git submodule deinit --all; \
        sudo -u luis git fetch origin; \
        sudo -u luis git checkout -- .; \
        sudo -u luis git reset origin/master --hard; \
        sudo -u luis git clean -fd; \
        sudo -u luis git gc --aggressive --auto; \
    )

# Remove unrequired dependencies
# hadolint ignore=SC2086
RUN                                                          : && \
    pacman -Rcsun --noprogressbar --noconfirm ansible          && \
    (unused_pkgs="$(pacman -Qqdt)";                               \
    if [ "$unused_pkgs" != "" ]; then                             \
        pacman -Rcsun $unused_pkgs --noprogressbar --noconfirm;   \
    fi )                                                       && \
                                                                  :

RUN                                              : && \
    rm -rf /etc/pacman.d/gnupg/openpgp-revocs.d/*  && \
    rm -rf /etc/pacman.d/gnupg/private-keys-v1.d/* && \
    rm -rf /etc/pacman.d/gnupg/pubring.gpg~        && \
    rm -rf /etc/pacman.d/gnupg/S.*                 && \
    rm -rf /var/cache/pacman/pkg/*                 && \
    rm -rf /var/lib/pacman/sync/*                  && \
    rm -rf /etc/hostname                           && \
    rm -rf /etc/machine-id                         && \
    rm -rf /tmp/*                                  && \
    rm -rf /root/*                                 && \
    rm -rf /home/docker/*                          && \
                                                      :
COPY --link ./deploy/docker/box/supervisord.conf /etc/supervisord.conf
RUN --network=none                                        : && \
                   chown root:root /etc/supervisord.conf    && \
                   chmod 755       /etc/supervisord.conf    && \
                                                               :

FROM scratch AS squash-stage

# set maintainer label
LABEL maintainer="Luís Ferreira <contact at lsferreira dot net>"

# Set common env vars
ENV LC_CTYPE 'en_US.UTF-8'
ENV LANG 'en_US.UTF-8'

# Use bash shell
SHELL [ "/usr/bin/bash", "-c" ]
ENV SHELL=/usr/bin/bash

# Copy everything
COPY --from=stage0 / /
WORKDIR /

# Specify the supervisor entrypoint
ENTRYPOINT [ "/usr/bin/supervisord", "-c", "/etc/supervisord.conf" ]

# Working directory
VOLUME  /home/luis/
