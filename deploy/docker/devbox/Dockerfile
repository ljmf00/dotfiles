# hadolint ignore=DL3007,DL3026
FROM ljmf00/archlinux:latest
LABEL maintainer="Luís Ferreira <contact at lsferreira.net>"

# Install base-devel, git and lib32- libs for gcc runtime and glibc
RUN pacman -Syyu --noprogressbar --needed --noconfirm \
        base-devel git lib32-gcc-libs lib32-glibc openssh python rsync ansible \
        bind-tools xdg-utils

# Add user
RUN /usr/sbin/useradd -m -G wheel -g users luis

WORKDIR /home/luis/

# Use bash shell
ENV SHELL=/bin/bash

# Give user permissions to use ping binary
RUN chmod 4755 /bin/ping

# Unset password to allow reset it
# hadolint ignore=DL3059
RUN passwd -d luis

# Copy current context to dotfiles folder
# hadolint ignore=DL3059
RUN mkdir -p /home/luis/dotfiles/
COPY . /home/luis/dotfiles/

RUN chown -R luis:wheel /home/luis/

# Run dotfiles, deploy ansible locally and clean dotfiles git repo
# hadolint ignore=DL3003,DL3004,SC2164
RUN : \
    && (cd dotfiles/deploy/ansible; \
        ansible-playbook playbooks/setup-box.yml; \
        ) \
    && sudo -u luis bash -c 'DOTFILES_WORKSPACE=personal ./dotfiles/configure.sh' \
    && (cd dotfiles; \
        rm -rf private/; \
        rm -rf .git/modules/private/; \
        sudo -u luis git checkout -- .; \
        sudo -u luis git reset origin/master --hard; \
        sudo -u luis git clean -fd; \
        sudo -u luis git gc --aggressive --auto; \
    )

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
