#                     16.04-py35  18.04-py36  20.04-py38
# ARG UBUNTU_TAG      16.04       18.04       20.04
# ARG PYTHON_VERSION  3           3           3

ARG UBUNTU_TAG
FROM ubuntu:$UBUNTU_TAG

MAINTAINER Mauricio Villegas <mauricio@omnius.com>

SHELL ["/bin/bash", "-c"]
ENV \
 DEBIAN_FRONTEND=noninteractive \
 LANG=en_US.UTF-8 \
 LC_ALL=C.UTF-8

ARG PYTHON_VERSION=3

RUN if ! test -n "$PYTHON_VERSION"; then \
      echo "error: PYTHON_VERSION argument is required"; \
      exit 1; \
    fi \
 && . /etc/os-release \
 && if [ "$VERSION_ID" = "16.04" ] && [ "$PYTHON_VERSION" = "2" ]; then \
      PYTHON_VERSION=; \
    elif [ "$PYTHON_VERSION" != "3" ]; then \
      echo "error: unsupported combination UBUNTU=$VERSION_ID PYTHON=$PYTHON_VERSION"; \
      exit 1; \
    fi \
 && apt-get update --fix-missing \
 && apt-get dist-upgrade -y \
 && apt-get install -y --no-install-recommends \
      less \
      nano \
      ca-certificates \
      git \
      g++ \
      swig \
      zip \
      unzip \
      locales \
      openssh-client \
      python$PYTHON_VERSION \
      python$PYTHON_VERSION-setuptools \
      python$PYTHON_VERSION-pkgconfig \
      python$PYTHON_VERSION-wheel \
      python$PYTHON_VERSION-pip \
      python$PYTHON_VERSION-dev \
      libxml2-dev \
      libxslt1-dev \
      libopencv-dev \
      libgdal-dev \
      libboost-all-dev \
      libopenblas-dev \
 && locale-gen en_US.UTF-8 \
 && if [ -f /usr/lib/x86_64-linux-gnu/pkgconfig/opencv4.pc ]; then \
      ln -s opencv4.pc /usr/lib/x86_64-linux-gnu/pkgconfig/opencv.pc; \
    fi \
 && pip3 install --no-cache-dir --upgrade pip setuptools \
 && apt-get autoremove -y \
 && apt-get purge -y $(dpkg -l | awk '{if($1=="rc")print $2}') \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

#RUN useradd -m -u 1234 pagexml-build
#WORKDIR /home/pagexml-build
#USER 1234
