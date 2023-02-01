FROM balenalib/raspberry-pi-debian:buster-20190325


ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
      build-essential \
      ca-certificates \
      cython3 \
      git \
      gpg \
      libudev-dev \
      libusb-1.0-0-dev \
      python3-dev \
      python3-pip \
      python3-tk \
      && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade setuptools pip

RUN pip install --no-cache-dir docutils

RUN useradd -ms /bin/bash trezor-agent
RUN usermod -aG plugdev trezor-agent

# Install trezor_agent
# RUN pip install hidapi trezor== trezor_agent==
# Patch: https://github.com/romanz/trezor-agent/pull/269
RUN pip install --no-cache-dir trezor==0.11.2

# Manually Install:
RUN git clone --depth=1 --branch=v0.13.1 https://github.com/romanz/trezor-agent /tmp/trezor-agent
WORKDIR /tmp/
RUN pip install --no-cache-dir -e trezor-agent/agents/trezor

WORKDIR /home/trezor-agent


USER trezor-agent
