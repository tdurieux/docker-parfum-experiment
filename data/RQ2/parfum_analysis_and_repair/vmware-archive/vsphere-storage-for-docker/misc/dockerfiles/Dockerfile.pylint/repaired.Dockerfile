#
# Dockerfile for running pylint
#
FROM alpine
MAINTAINER "CNA Storage Team" <cna-storage@vmware.com>

RUN apk add --no-cache --update --progress make wget python git
RUN wget --no-check-certificate -O - https://bootstrap.pypa.io/get-pip.py | python
RUN pip install --no-cache-dir --upgrade pip pylint pyvmomi pyvim
