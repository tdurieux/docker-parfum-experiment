#######################
# STEP 1: BUILD IMAGE #
#######################
FROM python:3.10-alpine AS build-image

RUN apk update \
 && apk add --no-cache \
        autoconf \
        automake \
        bash \
        build-base \
        cargo \
        cmake \
        g++ \
        gcc \
        git \
        libffi \
        libtool \
        czmq-dev \
        jpeg-dev \
        libffi-dev \
        libwebp-dev \
        libxml2-dev \
        libxslt-dev \
        make \
        musl-dev \
        openssl-dev \
        python3-dev \
        unixodbc-dev \
        zlib-dev


RUN /usr/local/bin/pip install poetry

ENV HOME="/app"
ENV VIRTUAL_ENV=/venv

WORKDIR $HOME

COPY pyproject.toml poetry.lock ./

RUN python3 -m venv $VIRTUAL_ENV            \
 && poetry config virtualenvs.create false  \
 && poetry install --no-interaction --no-dev --no-root

########################
# STEP 2: DEPLOY IMAGE #
########################