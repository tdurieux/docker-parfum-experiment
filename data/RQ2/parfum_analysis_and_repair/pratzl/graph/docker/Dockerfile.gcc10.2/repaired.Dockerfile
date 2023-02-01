FROM ubuntu:20.04

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update   

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
               apt-utils \
               man \
               manpages \
               make \
               ssh \
               tcsh \
               emacs \
               sudo && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
               cmake \
               git && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
               gcc-10 \
               g++-10 && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
								python3 \
								python3-pip && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
               libtbb2 \
               libtbb-dev && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends -y install \
               locate \
               && \
               updatedb && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y clean
RUN apt-get -y update

USER root
RUN \
       update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 90 --slave /usr/bin/g++ g++ /usr/bin/g++-10 \
    && update-alternatives --install /usr/bin/cc  cc /usr/bin/gcc 30						  \
    && update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10

RUN pip3 install --no-cache-dir conan

RUN useradd -m leonhard

USER leonhard
WORKDIR   /home/leonhard



ENV SHELL       /bin/bash

