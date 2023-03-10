# Note this works only in the Company VPN.

FROM ubuntu:20.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y gpg wget software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
    | gpg --batch --dearmor - \
    | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null

RUN apt-add-repository -y 'deb https://apt.kitware.com/ubuntu/ focal main'

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        curl \
        file \
        xz-utils \
        locales \
        git-core \
        make \
        cmake \
        gcc \
        g++ \
        python3 \
        vim \
        less && rm -rf /var/lib/apt/lists/*;


RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN groupadd -g <GID> qt && \
useradd -g <GID> -u <UID> -l -m -s /bin/bash qt

COPY toolchain.sh toolchain.sh
RUN chmod +x toolchain.sh && \
    ./toolchain.sh -d /opt/toolchain -y && \
    rm toolchain.sh && \
    chown -R qt:qt /opt/toolchain

RUN grep "export PATH" /opt/toolchain/environment-setup-* > /etc/profile.d/toolchain.sh

