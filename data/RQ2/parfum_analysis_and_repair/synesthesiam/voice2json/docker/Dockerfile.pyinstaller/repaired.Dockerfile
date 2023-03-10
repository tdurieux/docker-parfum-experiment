FROM ubuntu:eoan as build
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT

ENV LANG C.UTF-8

ENV LANG C.UTF-8

RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        python3 python3-dev python3-pip \
        build-essential \
        autoconf automake libtool \
        wget && rm -rf /var/lib/apt/lists/*;

# -----------------------------------------------------------------------------

RUN cd / && \
    wget 'https://github.com/pyinstaller/pyinstaller/releases/download/v3.6/PyInstaller-3.6.tar.gz' && \
    tar -xf /PyInstaller-3.6.tar.gz && rm /PyInstaller-3.6.tar.gz

RUN cd /PyInstaller-3.6/bootloader && \
    python3 ./waf all

RUN cd /PyInstaller-3.6 && \
    python3 -m pip install -e .