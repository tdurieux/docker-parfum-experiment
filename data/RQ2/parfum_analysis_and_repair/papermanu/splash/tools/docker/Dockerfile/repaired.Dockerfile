FROM ubuntu:18.04
MAINTAINER Emmanuel Durand <emmanueldurand@protonmail.com>

RUN apt update && apt upgrade -y
RUN DEBIAN_FRONTEND=noninterative apt -y --no-install-recommends install --assume-yes \
    zip \
    build-essential \
    git-core \
    cmake \
    automake \
    libgsl0-dev \
    libatlas3-base \
    libgl1-mesa-dev \
    libgphoto2-dev \
    libopencv-dev \
    libtool \
    libxcursor-dev \
    libxi-dev \
    libxinerama-dev \
    libxrandr-dev \
    libz-dev \
    python3-dev \
    portaudio19-dev \
    yasm && rm -rf /var/lib/apt/lists/*;

VOLUME /pkg

COPY build_package.sh /tmp/

ENTRYPOINT ["bash", "-c", "/tmp/build_package.sh ${*}", "--"]
