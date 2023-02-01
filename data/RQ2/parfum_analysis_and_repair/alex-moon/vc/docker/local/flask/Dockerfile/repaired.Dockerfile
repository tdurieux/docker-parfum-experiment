# FROM pytorch/pytorch:1.9.0-cuda11.1-cudnn8-runtime
FROM ubuntu:20.04

WORKDIR /opt/vc

RUN apt update \
    && apt install --no-install-recommends -y software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && apt update && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y \
    python3.9 \
    python3-pip \
    python3-venv \
    vim \
    less \
    git \
    wget \
    curl \
    ffmpeg \
    zip \
    redis-tools \
    supervisor && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000
EXPOSE 5001

CMD './docker.flask.sh'
