FROM ubuntu:18.04 AS base

LABEL maintainer="admin@blueoil.org"

RUN apt-get update && apt-get install --no-install-recommends -y \
    locales\
    python3 \
    python3-pip \
    libjpeg8-dev \
    zlib1g-dev \
    libfreetype6-dev \
    python3-opencv \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Locale setting
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

WORKDIR /home/blueoil
RUN pip3 install --no-cache-dir -U pip setuptools

FROM base AS blueoil-inference

# Install packages
COPY output_template/python/requirements.txt /home/blueoil/output_template/python/requirements.txt
RUN pip install --no-cache-dir -r /home/blueoil/output_template/python/requirements.txt

# Copy files for inference
COPY blueoil /home/blueoil/blueoil
COPY output_template /home/blueoil/output_template

WORKDIR /home/blueoil/output_template/python
ENV PYTHONPATH=/home/blueoil/output_template/python
RUN chmod 777 /home/blueoil/output_template/python/

FROM blueoil-inference AS blueoil-inference-dev

# Copy files for test
COPY tests tests
