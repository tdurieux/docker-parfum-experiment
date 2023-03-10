# Docker image for building Android APKs via buildozer
# Build with:
# docker build --tag=pywallet-android --file=dockerfiles/Dockerfile-android .
# Run with:
# docker run pywallet-android /bin/sh -c 'buildozer android debug'
# Or using the entry point shortcut:
# docker run pywallet-android 'buildozer android debug'
# Or for interactive shell:
# docker run -it --rm pywallet-android
FROM ubuntu:20.04

ARG TRAVIS=false
ENV USER="user"
ENV HOME_DIR="/home/${USER}"
ENV WORK_DIR="${HOME_DIR}" \
    PATH="${HOME_DIR}/.local/bin:${PATH}"


# configure locale
RUN apt update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt install -qq --yes --no-install-recommends \
    locales && \
    locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

# install build dependencies (required to successfully build the project)
RUN apt update -qq > /dev/null \
    && DEBIAN_FRONTEND=noninteractiv apt install -qq --yes --no-install-recommends \
    autoconf \
    automake \
    ca-certificates \
    cmake \
    curl \
    gettext \
    git \
    libffi-dev \
    libssl-dev \
    libltdl-dev \
    libpython3.8-dev \
    libtool \
    make \
    openjdk-8-jdk \
    patch \
    pkg-config \
    python3-setuptools \
    python3.8 \
    python3-pip \
    python3-setuptools \
    python \
    sudo \
    unzip \
    xz-utils \
    zip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# prepare non root env
RUN useradd --create-home --shell /bin/bash ${USER}
# with sudo access and no password
RUN usermod -append --groups sudo ${USER}
RUN echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${USER}
WORKDIR ${WORK_DIR}

# install buildozer and dependencies
RUN pip3 install --no-cache-dir --user --upgrade buildozer Cython==0.28.6

COPY . ${WORK_DIR}
# limits the amount of logs for Travis
RUN if [ "${TRAVIS}" = "true" ]; then sed 's/log_level = [0-9]/log_level = 1/' -i buildozer.spec; fi
ENTRYPOINT ["./dockerfiles/start.sh"]
