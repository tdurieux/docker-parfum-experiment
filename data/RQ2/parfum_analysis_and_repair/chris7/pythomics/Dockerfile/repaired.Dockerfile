FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    gcc \
    gfortran \
    libbz2-dev \
    liblzma-dev \
    libxml2-dev \
    libxslt1-dev \
    python3-dev \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f https://bootstrap.pypa.io/get-pip.py -o - | python3

WORKDIR pythomics
COPY Makefile MANIFEST.in setup.py setup.cfg tox.ini ./
COPY requirements requirements
RUN pip3 install --no-cache-dir -r requirements/testing.txt -r

COPY scripts scripts
COPY tests tests
COPY pythomics pythomics

RUN pip3 install --no-cache-dir -e .
