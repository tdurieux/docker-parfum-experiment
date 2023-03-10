# ==================================================================================================================
#
# Docker to ubuntu 18.04 image for Moja flint libraries and executables
#
# Building this Docker:
#   docker build  -f Dockerfile.flint.ubuntu.18.04 --build_arg BUILD_TYPE=RELEASE --build-arg NUM_CPU=4  --build-arg FLINT_BRANCH=develop -t moja/flint:ubuntu-18.04 .
#
# ==================================================================================================================

FROM moja/baseimage:ubuntu-18.04

LABEL maintainer="info@moja.global"

ARG FLINT_BRANCH
ARG NUM_CPU=1
ARG DEBIAN_FRONTEND=noninteractive
ARG BUILD_TYPE=DEBUG

ENV ROOTDIR /usr/local

WORKDIR $ROOTDIR/src

# set environment variables
ENV PATH $ROOTDIR/bin:$PATH
ENV LD_LIBRARY_PATH $ROOTDIR/lib:$ROOTDIR/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH
ENV PYTHONPATH $ROOTDIR/lib:$PYTHONPATH
ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
ENV GDAL_DATA=/usr/local/share/gdal
ENV GDAL_HTTP_VERSION 2
ENV GDAL_HTTP_MERGE_CONSECUTIVE_RANGES YES
ENV GDAL_HTTP_MULTIPLEX YES

RUN apt-get update -y && apt-get install --no-install-recommends -y doxygen doxygen-latex graphviz \
        postgis \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN	git clone --recursive https://github.com/sebastiandev/zipper.git \
	&& cd zipper && git checkout e9f150516cb55d194b5e01d21a9527783e98311d && mkdir build  && cd build \
	&& cmake .. \
	&& make --quiet -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src

# GET  moja.global
RUN git clone --recursive --depth 1 -b ${FLINT_BRANCH} https://github.com/moja-global/FLINT.git flint \
    && mkdir -p flint/Source/build && cd flint/Source/build \
    && cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE  \
            -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
            -DENABLE_TESTS:BOOL=OFF \
            -DENABLE_MOJA.MODULES.GDAL=ON \
            -DENABLE_MOJA.MODULES.LIBPQ=ON \
            -DBoost_USE_STATIC_LIBS=OFF \
            -DBUILD_SHARED_LIBS=ON .. \
	&& make --quiet -j $NUM_CPU \
	&& make --quiet install \
    && cd $ROOTDIR/src

RUN ln -s $ROOTDIR/lib/libmoja.modules.* $ROOTDIR/bin

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN pip3 install --no-cache-dir setuptools
RUN git clone --recursive --depth 1 -b ${FLINT_BRANCH}  https://github.com/moja-global/FLINT.data.git FLINT.data \
    && cd FLINT.data \
    && pip3 install --no-cache-dir .

RUN rm -Rf $ROOTDIR/src/* \
    && ldconfig

RUN useradd -ms /bin/bash moja
USER moja
WORKDIR /home/moja
