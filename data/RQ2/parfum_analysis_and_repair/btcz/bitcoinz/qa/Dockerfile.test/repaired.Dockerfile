FROM debian:stretch-slim as build

# Install our build dependencies
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    curl \
    build-essential \
   pkg-config \
   libc6-dev \
   m4 \
   g++-multilib \
    autoconf \
   libtool \
   ncurses-dev \
   unzip \
   git \
   python \
    python-pip \
    zlib1g-dev \
   wget \
   bsdmainutils \
   automake \
   p7zip-full \
   pwgen \
    vim \
  && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pyblake2 zmq

WORKDIR /usr/local/src/
COPY . /usr/local/src/

RUN ./zcutil/build.sh -j$(nproc)
RUN ./zcutil/fetch-params.sh

CMD ["bash"]
