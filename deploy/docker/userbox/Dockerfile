# hadolint ignore=DL3007,DL3026
FROM ljmf00/devbox:latest
LABEL maintainer="Luís Ferreira <contact at lsferreira.net>"

# Overwrite systemctl to work without systemd daemon
COPY deploy/docker/userbox/docker-systemctl /usr/bin/systemctl

# Enable SSH
RUN : \
    && systemctl enable sshd \
    && :

# hadolint ignore=DL3059
RUN sed -i 's/^\(session.*\)required\(.*pam_limits.so\)/\1optional\2/' /etc/pam.d/system-auth

COPY deploy/docker/userbox/docker-init /usr/local/bin/docker-init

CMD ["/usr/local/bin/docker-init"]
