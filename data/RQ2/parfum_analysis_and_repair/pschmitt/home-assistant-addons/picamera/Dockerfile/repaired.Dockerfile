FROM python:3

ARG BUILD_ARCH
ARG BUILD_VERSION

LABEL maintainer "Philipp Schmitt <philipp@schmitt.co>"

RUN apt-get update && \
    apt-get install --no-install-recommends -y jq && \
    READTHEDOCS=True pip3 --no-cache-dir install picamera && \
    rm -rf /var/lib/apt/lists/*

COPY web_streaming.py /web_streaming.py
COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
