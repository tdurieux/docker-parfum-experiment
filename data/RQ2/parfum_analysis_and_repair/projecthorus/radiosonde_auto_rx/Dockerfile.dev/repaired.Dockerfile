FROM debian:buster-slim

EXPOSE 5000/tcp

# Upgrade base packages and install dependencies.
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  build-essential \
  cmake \
  git \
  libatlas-base-dev \
  libatomic1 \
  libsamplerate-dev \
  libusb-1.0-0-dev \
  pkg-config \
  python3 \
  python3-dev \
  python3-pip \
  python3-setuptools \
  rng-tools \
  sox \
  tini \
  usbutils && \
  rm -rf /var/lib/apt/lists/*

# Compile rtl-sdr from source and install.
RUN git clone https://github.com/steve-m/librtlsdr.git /root/librtlsdr && \
  mkdir -p /root/librtlsdr/build && \
  cd /root/librtlsdr/build && \
  cmake -Wno-dev ../ && \
  make && \
  make install && \
  rm -rf /root/librtlsdr && \
  ldconfig

# Copy in requirements.txt.
COPY auto_rx/requirements.txt \
  /tmp/requirements.txt

# Install Python packages.
RUN --mount=type=cache,target=/root/.cache/pip pip3 install --no-cache-dir \
  --no-warn-script-location --no-binary numpy \
  -r /root/radiosonde_auto_rx/auto_rx/requirements.txt

# Run bash.
WORKDIR /root
CMD ["/bin/bash"]
