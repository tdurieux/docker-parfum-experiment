FROM ubuntu:18.04
LABEL maintainer="solidi"
LABEL version="0.1"
LABEL description="Base linux image to compile libs for Cold Ice Remastered."

RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial main" >> /etc/apt/sources.list
RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial universe" >> /etc/apt/sources.list

RUN apt update -y
RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends g++-4.8 gcc-4.8 -y && rm -rf /var/lib/apt/lists/*;
# For <sys/stat.h>
RUN apt-get install --no-install-recommends gcc-4.8-multilib g++-4.8-multilib -y && rm -rf /var/lib/apt/lists/*;
