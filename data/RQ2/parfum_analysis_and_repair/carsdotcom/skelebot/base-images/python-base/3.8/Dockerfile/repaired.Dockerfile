FROM python:3.8-slim
MAINTAINER Sean Shookman <sshookman@cars.com>

# Install basic compilers and libraries commonly needed for downstream packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y -q build-essential libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install -U pip
RUN pip --no-cache-dir install jupyter
RUN pip --no-cache-dir install jupyterlab
