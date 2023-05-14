# syntax=docker/dockerfile:1.4
FROM docker.io/ljmf00/archlinux:base AS stage0

# Init keyring
RUN pacman-key --init && \
    pacman-key --populate

RUN pacman -Syyu --noprogressbar --noconfirm kubo busybox

# hadolint ignore=SC3009
RUN --network=none mkdir -p /rootfs/ && \
                   mkdir -m 0755 -p /rootfs/usr/{bin,lib,include} && \
                   ln -s usr/bin /rootfs/bin && \
                   ln -s usr/lib /rootfs/lib && \
                   ln -s usr/lib /rootfs/lib64 && \
                   mkdir -m 0755 -p /rootfs/var/{cache,lib,log} /rootfs/{dev,run,etc} && \
                   mkdir -m 1777 -p /rootfs/tmp && \
                   mkdir -m 0555 -p /rootfs/{sys,proc} && \
                   mknod /rootfs/dev/null c 1 3

RUN --network=none                                 : && \
    busybox --install /rootfs/usr/bin                && \
    cp /usr/bin/ipfs /rootfs/usr/bin                 && \
    cp /usr/lib/libc.so.6 /rootfs/usr/lib            && \
    cp /usr/lib/ld-linux-x86-64.so.2 /rootfs/usr/lib

FROM scratch AS squash-stage
ENV LC_ALL 'C'

COPY --from=stage0 /rootfs/ /

EXPOSE 4001/tcp
EXPOSE 4001/udp

EXPOSE 5001/tcp
EXPOSE 8080/tcp

ENTRYPOINT [ "/usr/bin/ipfs", "daemon", "--init", "--migrate", "--enable-gc" ]
