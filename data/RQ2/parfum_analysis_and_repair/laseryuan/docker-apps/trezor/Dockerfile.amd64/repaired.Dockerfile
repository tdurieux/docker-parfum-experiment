FROM debian:buster-slim



ENV LANG C.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y \
      git \
      `# build support` \
      build-essential \
      `# python support` \
      cython3 \
      python3-dev \
      python3-pip \
      python3-tk \
      `# usb support` \
      libudev-dev \
      libusb-1.0-0-dev \
      `# protocol buffers` \
      libprotoc-dev \
      protobuf-compiler \
      `# ssl support` \
      libssl-dev \
      && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade setuptools pip

RUN git clone --depth=1 https://github.com/trezor/trezor-firmware /tmp/trezor
WORKDIR /tmp/trezor/python

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-optional.txt

RUN python3 setup.py install

RUN useradd -ms /bin/bash trezor
RUN usermod -aG plugdev trezor


USER trezor
WORKDIR /home/trezor/app
