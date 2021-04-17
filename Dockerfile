FROM archlinux
LABEL maintainer="Luís Ferreira <contact at lsferreira.net>"

# Add multilib repo
RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# WORKAROUND for glibc 2.33 and old Docker
RUN patched_glibc=glibc-linux4-2.33-4-x86_64.pkg.tar.zst && \
    curl -LO "https://repo.archlinuxcn.org/x86_64/$patched_glibc" && \
    bsdtar -C / -xvf "$patched_glibc"

# Install base-devel, git and lib32- libs for gcc runtime and glibc
RUN pacman -Syyu --noprogressbar --needed --noconfirm \
	base-devel git jq lib32-gcc-libs lib32-glibc

# Add user, group sudo
RUN /usr/sbin/groupadd --system sudo && \
    /usr/sbin/useradd -m --groups sudo luis && \
    /usr/sbin/sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    /usr/sbin/echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /home/luis/

# Install yay
RUN cd /tmp && \
    git clone https://aur.archlinux.org/yay.git && \
    chown -R luis:sudo yay && \
    cd yay && \
    sudo -u luis makepkg -sic --noprogressbar --noconfirm && \
    cd .. && rm -rf yay

# Install code-server from AUR
RUN sudo -u luis yay -S --noprogressbar --noconfirm code-server

# Use bash shell
ENV SHELL=/usr/bin/bash

# Set correct locale
RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf

RUN locale-gen en_US.UTF-8
ENV LC_CTYPE 'en_US.UTF-8'

RUN pacman -S --noprogressbar --needed --noconfirm \
	rclone rsync openssh python-pygments thefuck figlet fortune-mod inetutils

# Remove unrequired dependencies
RUN pacman -Rs jq --noprogressbar --noconfirm && \
    (unused_pkgs="$(pacman -Qqdt)"; \
    if [ "$unused_pkgs" != "" ]; then \
        pacman -Rns $unused_pkgs --noprogressbar --noconfirm; \
    fi )

# Remove cache and update trusted certs
RUN rm -rf /var/cache/pacman/pkg/* && \
    rm -rf /var/lib/pacman/sync/* && \
    rm -rf /tmp/* && \
    trust extract-compat

# Copy current context to dotfiles folder
RUN mkdir -p /home/luis/dotfiles/
ADD . /home/luis/dotfiles/

RUN chown -R luis:sudo /home/luis/

# Use our custom entrypoint script first
RUN cp /home/luis/dotfiles/deploy/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh && \
	chmod +x /usr/bin/deploy-container-entrypoint.sh

# Change to user luis
USER luis

# Port
ENV PORT=8080

# Define deploy entrypoint
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
