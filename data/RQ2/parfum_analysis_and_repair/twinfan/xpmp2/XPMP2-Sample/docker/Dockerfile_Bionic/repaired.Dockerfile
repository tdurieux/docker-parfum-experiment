# Linux compile environment, based on Ubuntu Bionic Beaver

### Ubuntu basics ########################################################

FROM ubuntu:18.04

# set up package manager with latest mirrors and certificates
RUN sed -i -e 's/http:\/\/archive.ubuntu.com\/ubuntu\//mirror:\/\/mirrors.ubuntu.com\/mirrors.txt/' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*;


### Linux ################################################################

# Install Linux toolchain (GCC) including CMake
RUN apt-get install -y --no-install-recommends build-essential ninja-build sudo bash coreutils curl libcurl4-openssl-dev \
 && apt-get clean \
 && curl -f -sSL https://github.com/Kitware/CMake/releases/download/v3.19.2/cmake-3.19.2-Linux-x86_64.tar.gz | tar -xz -C /usr/local/ --strip-components=1 \
 # Install dependency libraries under Linux.
 && apt-get install -y --no-install-recommends freeglut3-dev libudev-dev libopenal-dev \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

### User / Entrypoint ####################################################expor

# Add essential users to the docker image
RUN echo "" | adduser --uid 1000 --disabled-password  --gecos "" xpbuild && adduser xpbuild sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

VOLUME /build
USER xpbuild
ADD build.sh /usr/bin/build.sh

# Entrypoint is the build.sh script, which takes care of actual building
WORKDIR /build
ENTRYPOINT ["build.sh"]
