FROM ubuntu:14.04
MAINTAINER Alex Baden / Neurodata (neurodata.io)

RUN apt-get clean
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install \
  python-pip \
  python-all-dev \
  zlib1g-dev \
  libjpeg8-dev \
  libtiff4-dev \
  libfreetype6-dev \
  liblcms2-dev \
  libwebp-dev \
  tcl8.5-dev \
  tk8.5-dev \
  python-tk \
  libhdf5-dev \
  git vim && rm -rf /var/lib/apt/lists/*;

# install numpy
RUN pip install --no-cache-dir numpy

# install ndio
RUN pip install --no-cache-dir ndio


