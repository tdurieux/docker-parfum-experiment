FROM nvidia/cuda:11.6.0-devel-ubuntu20.04 AS joligan_build

# user jenkins
RUN addgroup --gid 127 jenkins
RUN adduser jenkins --uid 119 --gid 127 --system

# add missing apt dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && apt-get install --no-install-recommends -y \
    python3-pip \
    python3-opencv \
    python3-pytest \
    sudo \
    wget \
    git \
    unzip && rm -rf /var/lib/apt/lists/*;

USER jenkins
RUN mkdir /home/jenkins/app
WORKDIR /home/jenkins/app
ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir uvicorn fastapi
RUN mkdir .cache && mkdir .cache/torch
RUN export TORCH_HOME=/home/jenkins/app/.cache/torch

ADD . /home/jenkins/app