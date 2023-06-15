# syntax=docker/dockerfile:1.4
FROM ghcr.io/ljmf00/archlinux:base AS stage0

# Init keyring
RUN pacman-key --init && \
    pacman-key --populate

RUN pacman -Syyu --noprogressbar --noconfirm i2pd

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

COPY --link ./i2pd.conf /etc/i2pd/i2pd.conf

FROM scratch AS squash-stage
ENV LC_ALL 'C'

COPY --from=stage0 / /

EXPOSE 4447/tcp
EXPOSE 4447/udp

ENTRYPOINT [ "/usr/bin/i2pd", "--conf=/etc/i2pd/i2pd.conf" ]
