# public OSS users should simply leave this argument blank or ignore its presence entirely
ARG REGISTRY="mcr.microsoft.com/mirror/docker/library/"
FROM ${REGISTRY}python:3.8-slim-buster

WORKDIR /app

COPY ./scripts /app/stress/scripts

WORKDIR /app/stress/scripts
RUN pip3 install --no-cache-dir -r dev_requirement.txt
