FROM ubuntu:20.04

LABEL version="{{version}}"

WORKDIR /usr/src/app

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;

{{install requirements.txt}}

COPY LICENSE.md ./
COPY setup.py ./
COPY pyproject.toml ./
ADD spatialprofilingtoolbox/ ./spatialprofilingtoolbox
RUN pip install --no-cache-dir .

ENV DEBUG=1
