# This ARG isn't used but prevents warnings in the build
ARG REGISTRY
ARG CODE_VERSION
FROM python:3.7-slim-stretch

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

ENV PIP_DEFAULT_TIMEOUT=100
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -q requests==2.20.0 prometheus_client==0.1.* flatten_json==0.1.* six==1.12.*

COPY monitoring/front_end_exporter.py /usr/src/app
ENTRYPOINT ["python", "/usr/src/app/front_end_exporter.py"]

# vim: set filetype=dockerfile:
