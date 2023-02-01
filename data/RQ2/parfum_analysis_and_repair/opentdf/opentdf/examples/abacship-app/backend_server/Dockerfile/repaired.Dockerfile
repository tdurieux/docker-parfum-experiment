# Context: backend_server

ARG PY_VERSION=3.10
ARG ALPINE_VERSION=3.15

# stage - build
# FROM python:${PY_VERSION}-alpine${ALPINE_VERSION} AS build
FROM python:${PY_VERSION} as build

WORKDIR /build

COPY requirements.txt requirements.txt
COPY ./app ./app
RUN echo $(arch)
RUN pip3 install --no-cache-dir --upgrade pip setuptools
RUN pip3 install --no-cache-dir --requirement requirements.txt

# Server
ENV SERVER_ROOT_PATH "/"
ENV SERVER_PORT "4060"
ENV SERVER_PUBLIC_NAME ""
ENV SERVER_LOG_LEVEL "DEBUG"

#Endpoints