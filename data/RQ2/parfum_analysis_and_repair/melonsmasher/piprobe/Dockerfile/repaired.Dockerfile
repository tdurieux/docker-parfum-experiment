###
# Build image
###
FROM balenalib/raspberrypi3-alpine-python:3-3.9-build as build

ENV ADAFRUIT_DHT_PY_VERSION=1.4.0
ENV INFLUXDB_PY_VERSION=5.2.2
ENV CX_FREEZE_PY_VERSION=6.0b1

WORKDIR /usr/src/build

COPY piProbe.py piProbe.py

RUN apk update && \
    apk add --no-cache build-base musl-utils python3 python3-dev py3-openssl && \
    ln -s /lib/libc.musl-armv7.so.1 ldd && \
    ln -s /lib /lib64 && \
    python3 -m pip install --no-cache-dir --trusted-host pypi.python.org cx_Freeze==${CX_FREEZE_PY_VERSION} && \
    python3 -m pip install --no-cache-dir --trusted-host pypi.python.org influxdb==${INFLUXDB_PY_VERSION} && \
    python3 -m pip install --no-cache-dir --trusted-host pypi.python.org Adafruit_DHT==${ADAFRUIT_DHT_PY_VERSION} --install-option="--force-pi2" && \
    cxfreeze piProbe.py --target-dir dist --include-modules=multiprocessing,os,sys,influxdb,Adafruit_DHT,requests,idna.idnadata,urllib3

###
# Deployed image
###
FROM arm32v7/alpine:3.9

ENV AM_I_IN_A_DOCKER_CONTAINER=Yes

WORKDIR /usr/src/app

# Copy precompiled binary