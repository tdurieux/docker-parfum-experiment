FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  g++ \
  make \
  ninja-build \
  file \
  curl \
  ca-certificates \
  python3 \
  git \
  cmake \
  sudo \
  gdb \
  xz-utils \
  g++-powerpc-linux-gnuspe \
  libssl-dev \
  pkg-config && rm -rf /var/lib/apt/lists/*;


COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV HOSTS=powerpc-unknown-linux-gnuspe

ENV RUST_CONFIGURE_ARGS --enable-extended --disable-docs
ENV SCRIPT python3 ../x.py dist --host $HOSTS --target $HOSTS
