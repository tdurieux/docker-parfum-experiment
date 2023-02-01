FROM debian:sid-slim
#
# this file mirrors the build params used in the GitHub Actions and enables
# reproducible builds for downstream forks for Ziti contributors
#
# usage
# docker run with top-level of tunneler SDK repo mounted as writeable volume on /mnt

ARG uid=1000
ARG gid=1000
ENV TZ=Etc/UTC
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
# multi-platform stuff
RUN apt-get -y --no-install-recommends install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf gcc-aarch64-linux-gnu crossbuild-essential-arm64 && rm -rf /var/lib/apt/lists/*;
# tunneler SDK stuff
RUN apt-get -y update \
    && apt-get -y --no-install-recommends install \
        build-essential \
        cmake \
        curl \
        doxygen \
        git \
        graphviz \
        libsystemd-dev \
        iproute2 \
        pkg-config \
        python3 \
        zlib1g-dev \
        libssl-dev \
    && rm -rf /var/lib/apt/lists/*

USER ${uid}:${gid}
WORKDIR /mnt/
ENTRYPOINT ["/mnt/docker/linux-build.sh"]
