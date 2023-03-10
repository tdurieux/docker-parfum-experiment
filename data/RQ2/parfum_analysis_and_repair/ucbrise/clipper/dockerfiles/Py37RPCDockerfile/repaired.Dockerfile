# This ARG isn't used but prevents warnings in the build script
ARG REGISTRY
ARG CODE_VERSION
FROM python:3.7-slim-stretch

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN mkdir -p /model \
      && apt-get update -qq \
      && apt-get install --no-install-recommends -y -qq libzmq5 libzmq5-dev redis-server libsodium18 build-essential && rm -rf /var/lib/apt/lists/*;

ENV PIP_DEFAULT_TIMEOUT=100
RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir -q cloudpickle==0.5.* pyzmq==17.0.* prometheus_client==0.1.* \
    pyyaml >=4.2b1 jsonschema==2.6.* redis==2.10.* psutil==5.4.* flask==0.12.2 \
    numpy==1.14.*

COPY clipper_admin /clipper_admin/

RUN cd /clipper_admin \
    && pip install --no-cache-dir -q .

WORKDIR /container

COPY containers/python/__init__.py containers/python/rpc.py /container/

COPY monitoring/metrics_config.yaml /container/

ENV CLIPPER_MODEL_PATH=/model

HEALTHCHECK --interval=3s --timeout=3s --retries=1 CMD test -f /model_is_ready.check || exit 1

# vim: set filetype=dockerfile:
