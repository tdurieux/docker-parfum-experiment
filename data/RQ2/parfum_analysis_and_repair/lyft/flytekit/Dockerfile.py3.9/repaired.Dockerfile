FROM python:3.9-slim-buster

MAINTAINER Flyte Team <users@flyte.org>
LABEL org.opencontainers.image.source https://github.com/flyteorg/flytekit

WORKDIR /root
ENV PYTHONPATH /root

RUN pip install --no-cache-dir awscli
RUN pip install --no-cache-dir gsutil

ARG VERSION
ARG DOCKER_IMAGE

# Pod tasks should be exposed in the default image
RUN pip install --no-cache-dir -U flytekit==$VERSION flytekitplugins-pod==$VERSION

ENV FLYTE_INTERNAL_IMAGE "$DOCKER_IMAGE"
