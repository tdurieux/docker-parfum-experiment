FROM ubuntu:18.04

ENV MUV_CONSOLE_MODE true

WORKDIR /root

RUN env
RUN apt-get update -y -qq && apt-get install --no-install-recommends -y \
            blender \
            wget \
            python3 \
            python3-pip \
            zip && rm -rf /var/lib/apt/lists/*;

RUN wget https://mirror.cs.umn.edu/blender.org/release/Blender2.77/blender-2.77-linux-glibc211-x86_64.tar.bz2
RUN tar jxf blender-2.77-linux-glibc211-x86_64.tar.bz2 && rm blender-2.77-linux-glibc211-x86_64.tar.bz2
