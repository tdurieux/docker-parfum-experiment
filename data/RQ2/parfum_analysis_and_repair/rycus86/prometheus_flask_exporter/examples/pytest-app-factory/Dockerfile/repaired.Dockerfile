FROM python:3.8-alpine

RUN pip install --no-cache-dir flask pytest

ADD . /tmp/latest
RUN pip install --no-cache-dir -e /tmp/latest --upgrade

ENV PROMETHEUS_MULTIPROC_DIR /tmp
ENV prometheus_multiproc_dir /tmp
ENV PYTHONPATH=/data

ADD ./examples/pytest-app-factory /data
WORKDIR /data
