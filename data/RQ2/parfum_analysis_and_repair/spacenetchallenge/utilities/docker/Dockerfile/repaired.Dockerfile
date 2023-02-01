LABEL maintainer dlindenbaum


## List of Python packages needed
###dataTools
#import numpy as np
#from osgeo import ogr, gdal, osr
#import cv2
###evalTools
###geoTools
#from osgeo import gdal, osr, ogr
#    import rtree
#from osgeo import gdal, osr, ogr, gdalnumeric
#from PIL import Image

## Install External Libraries for Pillow
#apt-get install
#libjpeg
#zlib
#libtiff
#libfreetype
#littlecms
#libwebp
#openjpeg
#
### install Python openCV
#libopencv-dev \
#python-opencv \
#python-numpy \
#python-pip \
#python-setuptools \
#gdal-bin \
#python-gdal

## Install General Requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        cmake \
        git \
        wget \
        vim \
        python-dev \
        python-pip \
        python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

## Install Basics for Python
RUN apt-get update && apt-get install -y --no-install-recommends \
        python-numpy \
        python-scipy && rm -rf /var/lib/apt/lists/*;

## Install Essentials for Pillow
RUN apt-get update && apt-get install -y --no-install-recommends \
        libjpeg-dev \
        zlib1g \
        libtiff5-dev \
        libfreetype6-dev \
        libwebp-dev \
        libopenjpeg-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir Pillow

## Install GDAL Requirments
RUN apt-get update && apt-get install -y --no-install-recommends \
        gdal-bin \
        python-gdal && rm -rf /var/lib/apt/lists/*;

## Instal OpenCV Requirements
RUN apt-get update && apt-get install -y --no-install-recommends \
        libopencv-dev \
        python-opencv && rm -rf /var/lib/apt/lists/*;

## Install RTRee
RUN apt-get update && apt-get install -y --no-install-recommends \
        libspatialindex-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir rtree

## Install Python requirements

RUN pip install --no-cache-dir pandas geopandas

ENV GIT_BASE=/opt/
WORKDIR $GIT_BASE

# Download spaceNetUtilities
# FIXME: use ARG instead of ENV once DockerHub supports this

RUN git clone --depth 1 -b spacenetV3 https://github.com/SpaceNetChallenge/utilities.git
RUN pip install --no-cache-dir -e /opt/utilities/


#ENV PYUTILS_ROOT $GIT_BASE/utilities/python
#ENV PYTHONPATH $PYUTILS_ROOT:$PYTHONPATH

WORKDIR /workspace


