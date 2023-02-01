FROM python:3
MAINTAINER Jeff Grafton <jgrafton@google.com>

WORKDIR /workspace

RUN pip install --no-cache-dir pyyaml

COPY test.py configmap-*.yaml /workspace/

ENTRYPOINT /workspace/test.py
