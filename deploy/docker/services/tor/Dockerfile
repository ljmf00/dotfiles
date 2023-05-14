# syntax=docker/dockerfile:1.4
FROM docker.io/ljmf00/archlinux:base AS stage0

# Init keyring
RUN pacman-key --init && \
    pacman-key --populate

RUN pacman -Syyu --noprogressbar --noconfirm tor nyx

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

COPY --link ./torrc /etc/tor/torrc

FROM scratch AS squash-stage
ENV LC_ALL 'C'

COPY --from=stage0 / /

EXPOSE 9050/tcp
EXPOSE 9050/udp

EXPOSE 9053/tcp
EXPOSE 9053/udp

ENTRYPOINT [ "/usr/bin/tor" ]
