FROM nvidia/cuda:11.6.0-devel-ubuntu20.04 AS joligan_build

# add missing apt dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && apt-get install --no-install-recommends -y \
    python3-pip \
    python3-opencv \
    python3-pytest \
    sudo \
    wget \
    unzip \
    git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

WORKDIR /app
ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir uvicorn[standard] fastapi
RUN mkdir .cache && mkdir .cache/torch
RUN export TORCH_HOME=/app/.cache/torch

ADD . /app
