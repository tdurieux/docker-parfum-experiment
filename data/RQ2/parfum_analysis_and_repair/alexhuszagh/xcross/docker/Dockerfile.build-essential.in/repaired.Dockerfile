# Essential packages for a build environment.
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install --assume-yes --no-install-recommends \
    autoconf \
    ca-certificates \
    cmake \
    git \
    make \
    ninja-build && rm -rf /var/lib/apt/lists/*;
