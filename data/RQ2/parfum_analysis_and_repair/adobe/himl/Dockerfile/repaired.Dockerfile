FROM python:3.10.5-slim@sha256:2ae2b820fbcf4e1c5354ec39d0c7ec4b3a92cce71411dfde9ed91d640dcdafd8

WORKDIR /config-merger

ADD . /config-merger/

RUN apt-get update && apt-get install --no-install-recommends -y make curl && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip && pip3 install --no-cache-dir .
RUN rm -rf /config-merger/*
