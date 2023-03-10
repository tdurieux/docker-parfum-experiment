FROM python:3.8-slim-buster

LABEL maintainer="Raetha"

COPY wyzesense2mqtt /wyzesense2mqtt/

RUN pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir -r /wyzesense2mqtt/requirements.txt \
    && chmod u+x /wyzesense2mqtt/service.sh

RUN apt-get update \
    && apt-get install -y --no-install-recommends vim \
    && rm -rf /var/lib/apt/lists/*

VOLUME /wyzesense2mqtt/config /wyzesense2mqtt/logs

ENTRYPOINT /wyzesense2mqtt/service.sh