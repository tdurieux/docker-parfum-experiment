# Dockerfile for Azure/batch-shipyard (Cascade/Docker)

FROM alpine:3.10
MAINTAINER Fred Park <https://github.com/Azure/batch-shipyard>

# copy in files
COPY cascade.py perf.py cascade.sh requirements.txt /opt/batch-shipyard/

# add dependencies and compile python files
RUN apk update \
    && apk add --update --no-cache \
        musl build-base python3 python3-dev openssl-dev libffi-dev \
        ca-certificates openssl docker bash \
    && python3 -m pip install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir --upgrade -r /opt/batch-shipyard/requirements.txt \
    && apk del --purge build-base python3-dev openssl-dev libffi-dev \
    && rm /var/cache/apk/* \
    && python3 -m compileall -f /opt/batch-shipyard

# set command