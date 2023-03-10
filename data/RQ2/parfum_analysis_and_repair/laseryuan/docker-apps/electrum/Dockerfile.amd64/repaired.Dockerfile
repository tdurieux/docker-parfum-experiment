FROM debian:buster-20190326-slim



ENV LANG C.UTF-8

# RUN apt-get update && apt-get install --no-install-recommends -y \
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    cython3 \
    git \
    libprotoc-dev \
    libssl-dev \
    libudev-dev \
    libusb-1.0-0-dev \
    protobuf-compiler \
    pyqt5-dev-tools \
    python3-dev \
    python3-pip \
    python3-pyqt5 \
    zbar-tools `# qrcode reader` \
    && rm -rf /var/lib/apt/lists/*


RUN pip3 install --no-cache-dir --upgrade setuptools pip

# Install trezor
RUN pip install --no-cache-dir trezor==0.11.2

# Install ledger
RUN pip3 --no-cache-dir install btchip-python

# Install electrum
RUN git clone --depth=1 --branch 3.3.5 https://github.com/spesmilo/electrum.git /tmp/electrum
WORKDIR /tmp/electrum
RUN python3 -m pip install .[fast]
RUN protoc --proto_path=electrum --python_out=electrum electrum/paymentrequest.proto

## Not work for raspberry due to pyaes==1.6.1 sha256 mismatch
RUN ./contrib/make_packages

# Add user
RUN useradd -ms /bin/bash electrum
RUN usermod -aG plugdev electrum

# wallet mount point
RUN mkdir /tmp/wallet
RUN chown electrum:electrum /tmp/wallet


USER electrum
WORKDIR /home/electrum
