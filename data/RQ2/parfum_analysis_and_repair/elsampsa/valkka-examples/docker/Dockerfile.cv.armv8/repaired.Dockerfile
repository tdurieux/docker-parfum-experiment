# python computer vision packages for arm
FROM arm64v8/ubuntu:18.04
# https://hub.docker.com/r/arm64v8/ubuntu
# https://github.com/docker-library/official-images#architectures-other-than-amd64

USER root

ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY qemu-arm-static /usr/bin/qemu-arm-static

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 mesa-utils glew-utils python3-numpy v4l-utils python3-pip openssl zip wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;
## this probably compiles opencv in the target system:
# pip3 wheel --wheel-dir=YOUR_DIRECTORY -r requirements.txt

## prepare build environment
RUN apt-get install --no-install-recommends -y yasm cmake pkg-config swig libglew-dev mesa-common-dev python3-dev python3-numpy libasound2-dev libssl-dev coreutils valgrind pkg-config && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gcc-arm-linux-gnueabi && rm -rf /var/lib/apt/lists/*;
## do the build with docker run command
WORKDIR /valkka
