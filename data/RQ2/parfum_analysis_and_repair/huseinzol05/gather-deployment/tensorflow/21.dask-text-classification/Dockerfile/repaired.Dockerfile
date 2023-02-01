FROM ubuntu:18.04 AS base

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    wget && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir numpy "dask[complete]"
RUN pip3 install --no-cache-dir tensorflow

WORKDIR /app

COPY . /app
