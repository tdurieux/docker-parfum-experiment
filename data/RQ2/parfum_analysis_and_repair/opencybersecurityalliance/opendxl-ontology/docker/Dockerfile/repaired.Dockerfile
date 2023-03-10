FROM node:10-stretch-slim

VOLUME ["/odev"]

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl git unzip wget telnet vim gnupg iproute2 python python-pip \
    && npm install -g bootprint \
    && npm install -g bootprint-opendxl \
    && apt-get remove -y --auto-remove build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /root/dxlschema/v0.1 \
    && cd /root/dxlschema/v0.1 \
    && wget https://opendxl.github.io/opendxl-api-specification/v0.1/schema.json \
    && pip install --no-cache-dir twine jsonschema && npm cache clean --force;

RUN cd /root \
    && npm install -g json-schema-ref-parser \
    && cd .. \
    && npm link json-schema-ref-parser && npm cache clean --force;

COPY files/deref.js /root
