FROM debian:jessie

WORKDIR /build
COPY requirements.txt /build/requirements.txt
COPY requirements-dev.txt /build/requirements-dev.txt

RUN apt-get update; \
    #apt-get install -y python-setuptools python-numpy python-dev libgdal-dev python-gdal gdal-bin swig git g++; \
    apt-get install --no-install-recommends -y python-dev python-setuptools libgdal-dev gdal-bin swig git g++; rm -rf /var/lib/apt/lists/*; \
    easy_install pip; \
    pip install --no-cache-dir numpy==1.9.1;

RUN \
    pip install --no-cache-dir -r requirements.txt; \
    pip install --no-cache-dir -r requirements-dev.txt;

