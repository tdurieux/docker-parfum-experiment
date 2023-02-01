FROM ubuntu:18.04

USER root

ENV TZ=Europe/Helsinki
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 mesa-utils glew-utils python3-numpy v4l-utils python3-pip openssl zip wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;

## prepare build environment
RUN apt-get install --no-install-recommends -y yasm cmake pkg-config swig libglew-dev mesa-common-dev python3-dev python3-numpy libasound2-dev libssl-dev coreutils valgrind pkg-config && rm -rf /var/lib/apt/lists/*;

## do the build with docker run command
WORKDIR /valkka
