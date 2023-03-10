FROM balenalib/raspberry-pi-debian:buster-20190325


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

RUN git clone --depth=1 --branch=v0.9.1 https://github.com/trezor/python-trezor /tmp/trezor
WORKDIR /tmp/trezor

RUN git submodule update --init
RUN pip install --no-cache-dir -r requirements.txt

RUN python3 setup.py install

# Install ledger
RUN pip3 --no-cache-dir install btchip-python

# Install electrum-btcp
RUN git clone --depth=1 --branch P!1.1.1 https://github.com/BTCPrivate/electrum-btcp /electrum-btcp
WORKDIR /electrum-btcp
RUN pip install --no-cache-dir -r requirements.txt

# Build icons
RUN pyrcc5 icons.qrc -o gui/qt/icons_rc.py

RUN pip install --no-cache-dir -U protobuf
RUN protoc --proto_path=lib/ --python_out=lib/ lib/paymentrequest.proto

# Add user
RUN useradd -ms /bin/bash electrum-btcp
RUN usermod -aG plugdev electrum-btcp

# wallet mount point
RUN mkdir /tmp/wallet
RUN chown electrum-btcp:electrum-btcp /tmp/wallet


USER electrum-btcp
