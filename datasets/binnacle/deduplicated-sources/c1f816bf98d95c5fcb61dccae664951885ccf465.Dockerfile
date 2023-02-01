FROM ubuntu:trusty

RUN apt-get update
RUN apt-get -y install curl gcc g++ python3.4 python3.4-venv make

RUN curl https://cmake.org/files/v3.12/cmake-3.12.2-Linux-x86_64.sh -o /tmp/cmake.sh
RUN sh /tmp/cmake.sh --exclude-subdir --prefix=/usr/local
