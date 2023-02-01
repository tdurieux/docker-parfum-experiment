FROM python:3.6-slim-stretch

#
# Container environment variables
#
ENV LANG C.UTF-8
ENV PYTHONUNBUFFERED 1

#
# Project directory
#
RUN mkdir /discovery
VOLUME /discovery
WORKDIR /discovery

#
# Application base dependencies
#
RUN apt-get update -y && apt-get install -y git gcc g++

#
# Python environment
#
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements-dev.txt /tmp/requirements-dev.txt

RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements-dev.txt
