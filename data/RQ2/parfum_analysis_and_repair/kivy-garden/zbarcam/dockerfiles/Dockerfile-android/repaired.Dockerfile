# Docker image for building Android APKs via buildozer
# Build with:
# docker build --tag=zbarcam-android --file=dockerfiles/Dockerfile-android .
# Run with:
# docker run zbarcam-android /bin/sh -c 'buildozer android debug'
# Or using the entry point shortcut:
# docker run zbarcam-android 'buildozer android debug'
# Or for interactive shell:
# docker run -it --rm zbarcam-android
FROM ubuntu:18.04

ARG CI=false
ENV USER="user"
ENV HOME_DIR="/home/${USER}"
ENV WORK_DIR="${HOME_DIR}" \
    PATH="${HOME_DIR}/.local/bin:${PATH}"


# configure locale
RUN apt update -qq > /dev/null && apt install -qq --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# install system dependencies
RUN apt update -qq > /dev/null && apt install -qq --yes --no-install-recommends \
    autoconf \
    automake \
    ca-certificates \
    cmake \
    curl \
    gettext \
    git \
    libffi-dev \
    libltdl-dev \
    libpython3.7-dev \
    libssl-dev \
    libtool \
    make \
    openjdk-8-jdk \
    pkg-config \
    python3.7 \
    python3-pip \
    python3-setuptools \
    python \
    sudo \
    unzip \
    xz-utils \
    zip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# prepare non root env, with sudo access and no password
RUN useradd --create-home --shell /bin/bash ${USER} && \
    usermod -append --groups sudo ${USER} && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER}
WORKDIR ${WORK_DIR}

# install buildozer & dependencies
RUN pip3 install --no-cache-dir --user --upgrade buildozer Cython==0.28.6

COPY . ${WORK_DIR}
# limits the amount of logs for Travis
RUN if [ "${CI}" = "true" ]; then sed 's/log_level = [0-9]/log_level = 1/' -i buildozer.spec; fi
ENTRYPOINT ["./dockerfiles/start.sh"]
