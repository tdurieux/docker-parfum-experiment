# Docker image for building Android APKs via buildozer
# Build with:
# docker build --tag=andremiras/etherollapp-android --file=dockerfiles/Dockerfile-android .
# Run with:
# docker run -it --rm andremiras/etherollapp-android buildozer android debug
# Or for interactive shell:
# docker run -it --rm andremiras/etherollapp-android
FROM ubuntu:18.04

ENV USER="user"
ENV HOME_DIR="/home/${USER}"
ENV WORK_DIR="${HOME_DIR}/app" \
    PATH="${HOME_DIR}/.local/bin:${PATH}"


# configure locale
RUN apt update -qq > /dev/null && apt install -qq --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/*
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# install minimal system dependencies
RUN apt update -qq > /dev/null && apt install -qq --yes --no-install-recommends \
    make \
    sudo && \
    rm -rf /var/lib/apt/lists/*

# prepare non root env, with sudo access and no password
RUN useradd --create-home --home-dir ${HOME_DIR} --shell /bin/bash ${USER} && \
    usermod -append --groups sudo ${USER} && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir ${WORK_DIR} && \
    chown ${USER}:${USER} -R ${WORK_DIR}

USER ${USER}
WORKDIR ${WORK_DIR}

# install system dependencies
# install buildozer & dependencies and enforces buildozer master (d483847) until next release
# TODO: d483847 -> a294071