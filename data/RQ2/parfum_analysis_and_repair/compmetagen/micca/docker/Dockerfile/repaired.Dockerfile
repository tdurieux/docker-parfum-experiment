FROM compmetagen/rdpclassifier:2.12_debian9
MAINTAINER Davide Albanese <davide.albanese@gmail.com>

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python2.7 \
    python-pip \
    python-dev \
    python-numpy \
    python-scipy \
    python-matplotlib \
    git \
    autoconf \
  && python -m pip install --upgrade pip \
  && pip install --no-cache-dir 'setuptools >=14.0' \
  && git clone https://github.com/compmetagen/micca.git /tmp/micca/ \
  && pip install --no-cache-dir /tmp/micca/ \
  && rm -rf /var/lib/apt/lists/* /tmp/micca
