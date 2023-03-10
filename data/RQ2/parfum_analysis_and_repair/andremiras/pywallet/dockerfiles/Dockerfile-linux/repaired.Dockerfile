# Docker image for installing dependencies on Linux and running tests.
# Build with:
# docker build --tag=pywallet-linux --file=dockerfiles/Dockerfile-linux .
# Run with:
# docker run pywallet-linux 'make test'
# Or for interactive shell:
# docker run -it --rm pywallet-linux
# You may need to allow X Server access:
# xhost +si:localuser:$USER
FROM ubuntu:20.04

ENV USER="user"
ENV HOME_DIR="/home/${USER}"
ENV WORK_DIR="${HOME_DIR}/app"

# configure locale
RUN apt update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt install -qq --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# install minimal system dependencies
RUN apt update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt install -qq --yes --no-install-recommends \
    make \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# prepare non root env, with sudo access and no password
RUN useradd --create-home --home-dir ${HOME_DIR} --shell /bin/bash ${USER} && \
    usermod -append --groups sudo ${USER} && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir ${WORK_DIR} && \
    chown ${USER}:${USER} -R ${WORK_DIR}

USER ${USER}
WORKDIR ${WORK_DIR}

# install system dependencies