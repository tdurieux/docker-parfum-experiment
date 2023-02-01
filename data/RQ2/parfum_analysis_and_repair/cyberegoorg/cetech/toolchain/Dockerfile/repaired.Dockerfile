FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y clang \
                                         cmake \
                                         gcc \
                                         g++ \
                                         git \
                                         pkgconf \
                                         libbsd-dev \
                                         tcl \
                                         libx11-dev \
                                         libjemalloc-dev \
                                         libgl1-mesa-dev \
                                         zlib1g-dev \
                                         liblzma-dev \
                                         python3-pip \
                                         python-dev \
                                         cython3 && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /tmp/requirements.txt

RUN pip3 install --no-cache-dir -r /tmp/requirements.txt
