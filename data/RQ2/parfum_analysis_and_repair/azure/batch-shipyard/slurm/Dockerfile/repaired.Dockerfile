# Dockerfile for Azure/batch-shipyard (Slurm)

FROM alpine:3.10
MAINTAINER Fred Park <https://github.com/Azure/batch-shipyard>

# copy in files
COPY slurm.py requirements.txt /opt/batch-shipyard/

# add base packages and python dependencies
RUN apk update \
    && apk add --update --no-cache \
        musl build-base python3 python3-dev openssl-dev libffi-dev \
        ca-certificates cifs-utils bash \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --upgrade -r /opt/batch-shipyard/requirements.txt \
    && apk del --purge \
        build-base python3-dev openssl-dev libffi-dev \
    && rm /var/cache/apk/* \
    && rm -f /opt/batch-shipyard/requirements.txt

# pre-compile files
RUN python3 -m compileall -f /opt/batch-shipyard

# set entrypoint