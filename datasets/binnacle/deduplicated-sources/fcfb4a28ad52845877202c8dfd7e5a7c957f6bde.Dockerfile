FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y g++ make libqt4-dev libgtest-dev dpkg-dev ccache wget file

RUN wget https://cmake.org/files/v3.10/cmake-3.10.1-Linux-x86_64.sh && bash cmake-3.10.1-Linux-x86_64.sh --skip-license && rm cmake-3.10.1-Linux-x86_64.sh
