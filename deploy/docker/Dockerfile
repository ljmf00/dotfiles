# hadolint ignore=DL3007
FROM ljmf00/archlinux:latest
LABEL maintainer="Luís Ferreira <contact at lsferreira.net>"

# Install base-devel, git and lib32- libs for gcc runtime and glibc
RUN pacman -Syyu --noprogressbar --needed --noconfirm \
	base-devel git lib32-gcc-libs lib32-glibc openssh python rsync ansible

# Overwrite systemctl to work without systemd daemon
COPY deploy/docker/docker-systemctl /usr/bin/systemctl

# Add user
RUN /usr/sbin/useradd -m -G wheel -g users luis

WORKDIR /home/luis/

# Use bash shell
ENV SHELL=/bin/bash

# Enable SSH
RUN : \
    && systemctl enable sshd \
    && :

# Give user permissions to use ping binary
RUN chmod 4755 /bin/ping

# Unset password to allow reset it
RUN passwd -d luis

# Copy current context to dotfiles folder
RUN mkdir -p /home/luis/dotfiles/
COPY . /home/luis/dotfiles/

RUN chown -R luis:wheel /home/luis/

# Run dotfiles, deploy ansible locally and clean dotfiles git repo
# hadolint ignore=DL3003,DL3004,SC2164
RUN : \
    && sudo -u luis ./dotfiles/configure.sh \
    && (cd dotfiles/deploy/ansible; \
        ansible-playbook playbooks/setup-box.yml; \
        ) \
    && (cd dotfiles; \
        rm -rf private/; \
        git checkout .; \
        git reset origin/master --hard; \
        git clean -fd; \
        git gc --aggressive --auto; \
    )

# hadolint ignore=DL3059
RUN sed -i 's/^\(session.*\)required\(.*pam_limits.so\)/\1optional\2/' /etc/pam.d/system-auth

# Remove unrequired dependencies
# hadolint ignore=SC2086
RUN (unused_pkgs="$(pacman -Qqdt)"; \
    if [ "$unused_pkgs" != "" ]; then \
        pacman -Rns $unused_pkgs --noprogressbar --noconfirm; \
    fi )

# Remove cache and update trusted certs
RUN rm -rf /var/cache/pacman/pkg/* && \
    rm -rf /var/lib/pacman/sync/* && \
    rm -rf /tmp/* && \
    trust extract-compat

COPY deploy/docker/docker-init /usr/local/bin/docker-init

CMD ["/usr/local/bin/docker-init"]
