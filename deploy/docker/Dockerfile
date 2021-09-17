FROM archlinux
LABEL maintainer="Luís Ferreira <contact at lsferreira.net>"

# Add multilib repo
RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# Install base-devel, git and lib32- libs for gcc runtime and glibc
RUN pacman -Syyu --noprogressbar --needed --noconfirm \
	base-devel git lib32-gcc-libs lib32-glibc openssh python rsync ansible

# Overwrite systemctl to work without systemd daemon
COPY deploy/docker/docker-systemctl /usr/bin/systemctl

# Add user, group sudo
RUN /usr/sbin/useradd -m -G wheel -g users luis && \
    /usr/sbin/sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    /usr/sbin/echo '%wheel ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99-wheel-group

WORKDIR /home/luis/

# Install yay
RUN cd /tmp && \
    git clone https://aur.archlinux.org/yay.git && \
    chown -R luis:wheel yay && \
    cd yay && \
    sudo -u luis makepkg -sic --noprogressbar --noconfirm && \
    cd .. && rm -rf yay

# Use bash shell
ENV SHELL=/bin/bash

# Set correct locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

RUN locale-gen en_US.UTF-8
ENV LC_CTYPE 'en_US.UTF-8'

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
ADD . /home/luis/dotfiles/

RUN chown -R luis:wheel /home/luis/

# Run dotfiles, deploy ansible locally and clean dotfiles git repo
RUN : \
    && sudo -u luis ./dotfiles/scripts/apply-dotfiles.sh \
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

# Remove unrequired dependencies
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
