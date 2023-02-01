# btw i use arch :^)
FROM archlinux:latest

# Setup arguments
ARG NODE_VERSION=node

# Setup environment variables
ENV USERNAME=arisu
ENV USER_UID=1000
ENV USER_GID=${USER_UID}

# Setup Arch Linux environment
RUN pacman -Syu --noconfirm && \
    pacman -Sy --noconfirm sudo git curl neofetch yarn

# Setup user
RUN groupadd -g ${USER_GID} ${USERNAME} && \
    useradd -u ${USER_UID} -g ${USER_GID} -m -s /bin/bash -d /home/${USERNAME} ${USERNAME} && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chown ${USERNAME}:${USERNAME} "/home/${USERNAME}/.bashrc"

# Setup Node.js + Yarn