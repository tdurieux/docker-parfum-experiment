ARG PYTHON_VERSION
FROM python:$PYTHON_VERSION-alpine

RUN apk add --no-cache bash git socat
RUN pip install --no-cache-dir tox

WORKDIR /src
