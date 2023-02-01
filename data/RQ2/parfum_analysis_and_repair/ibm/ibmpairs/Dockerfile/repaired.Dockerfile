#########################################################
# IBM PAIRS API wrapper docker image generation         #
#########################################################
# Copyright 2019 Physical Analytics, IBM Research, IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: BSD-3-Clause

FROM alpine:3.8

# variable settings
MAINTAINER IBM PAIRS "pairs@us.ibm.com"
ENV PYTHONUNBUFFERED 1

# install required Alpine software
RUN apk add --no-cache \
    libffi \
    libffi-dev \
    python3-dev \
    zlib-dev \
    jpeg-dev \
    tiff-dev \
    g++ \
    make \
    musl-dev \
    zeromq-dev \
    git

# compile and install GEOS specific software (required for shapely)
ADD http://download.osgeo.org/geos/geos-3.6.2.tar.bz2 /root/
RUN cd /root && tar xjf geos-3.6.2.tar.bz2 && rm geos-3.6.2.tar.bz2
RUN cd /root/geos-3.6.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-python && \
    make && \
    make install
RUN geos-config --cflags

# install required Python modules
RUN pip3 install --no-cache-dir --upgrade pip
## IBM PAIRS API wrapper requirements
RUN pip3 install --no-cache-dir \
    future \
    requests \
    geojson \
    numpy \
    pandas \
    shapely \
    Pillow
# installs not strictly required for running the IBM PAIRS
## Jupyter notebook for IBM PAIRS tutorial
RUN apk add --no-cache \
    libpng-dev \
    freetype-dev
RUN pip3 install --no-cache-dir \
    jupyter \
    urllib3 \
    urlparse3 \
    matplotlib
## install tools for development
RUN pip3 install --no-cache-dir \
    responses
RUN apk add --no-cache \
    vim

# add IBM PAIRS to installation
RUN     adduser -D ibmpairs
WORKDIR /home/ibmpairs
# add tutorials to the installation
COPY    tutorials/* /home/ibmpairs
# add the IBM PAIRS open-source code
COPY    ibmpairs    /home/ibmpairs/ibmpairs
# set correct permissions
RUN     chown ibmpairs:ibmpairs /home/ibmpairs/*

# start python environment as Jupyter notebook
EXPOSE  18380:18380
ENTRYPOINT su -c "\
    jupyter notebook \
        --ip 0.0.0.0 \
        --port 18380 \
        --no-browser \
        --NotebookApp.token='' \
    " ibmpairs
