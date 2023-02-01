FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install --no-install-recommends -y \
        build-essential \
        unzip \
        wget \
        git \
        cmake \
        pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src

ARG DCMTK_URL=https://dicom.offis.de/download/dcmtk/dcmtk362/dcmtk-3.6.2.zip

RUN wget $DCMTK_URL \
    && unzip -qq dcmtk-3.6.2.zip

RUN apt-get install --no-install-recommends -y \
    libboost-all-dev \
    libjpeg-dev \
    libopenslide-dev \
    libjsoncpp-dev \
    liblzma-dev \
    libxml2-dev \
    libopenjp2-7-dev && rm -rf /var/lib/apt/lists/*;

ARG GCP_URL=https://github.com/jcupitt

RUN git clone $GCP_URL/wsi-to-dicom-converter.git \
    && cd wsi-to-dicom-converter \
    && git checkout fix-compile \
    && mkdir build \
    && cd build \
    && cp -R /usr/local/src/dcmtk-3.6.2 . \
    && cmake .. \
    && make V=0 \
    && make install

WORKDIR /data
