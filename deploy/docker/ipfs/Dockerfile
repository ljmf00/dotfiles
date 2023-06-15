# syntax=docker/dockerfile:1.4
FROM ghcr.io/ljmf00/archlinux:base AS stage0

RUN pacman -Syyu --noprogressbar --noconfirm kubo
RUN rm -rf /etc/pacman.d/gnupg/openpgp-revocs.d/*  && \
    rm -rf /etc/pacman.d/gnupg/private-keys-v1.d/* && \
    rm -rf /etc/pacman.d/gnupg/pubring.gpg~        && \
    rm -rf /etc/pacman.d/gnupg/S.*                 && \
    rm -rf /var/cache/pacman/pkg/*                 && \
    rm -rf /var/lib/pacman/sync/*

FROM scratch AS squash-stage
ENV LC_ALL 'C'

COPY --from=stage0 / /

EXPOSE 4001/tcp
EXPOSE 4001/udp

EXPOSE 5001/tcp
EXPOSE 8080/tcp

ENTRYPOINT [ "/usr/bin/ipfs", "daemon", "--init", "--migrate", "--enable-gc" ]
