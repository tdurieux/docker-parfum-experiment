FROM ioft/i386-ubuntu
MAINTAINER Jo�l Troch <joel.troch62@gmail.com>
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install build-essential git wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /home/docker/cmake_bin
RUN wget --no-check-certificate --quiet -O - https://www.cmake.org/files/v3.6/cmake-3.6.3-Linux-i386.tar.gz | tar --strip-components=1 -xz -C /home/docker/cmake_bin
WORKDIR /home/docker