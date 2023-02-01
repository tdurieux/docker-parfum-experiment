FROM ubuntu:18.04

RUN set -xe

ENV HOME /src
ENV DEBIAN_FRONTEND noninteractive
ENV TERM=xterm

WORKDIR /usr/local/src
RUN apt-get -qqy update
RUN apt-get -qqy --no-install-recommends install wget build-essential git libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip libc-bin binutils && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pygame
RUN pip3 install --no-cache-dir "numpy==1.13.3"
RUN pip3 install --no-cache-dir cython
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir pyinstaller







