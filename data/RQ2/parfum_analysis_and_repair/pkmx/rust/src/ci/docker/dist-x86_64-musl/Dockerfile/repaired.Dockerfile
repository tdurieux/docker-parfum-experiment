FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  g++ \
  make \
  file \
  curl \
  ca-certificates \
  python2.7 \
  git \
  cmake \
  xz-utils \
  sudo \
  gdb \
  patch \
  libssl-dev \
  pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /build/
COPY dist-x86_64-musl/build-musl.sh /build/
RUN sh /build/build-musl.sh && rm -rf /build

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV RUST_CONFIGURE_ARGS \
      --target=x86_64-unknown-linux-musl \
      --musl-root-x86_64=/musl-x86_64 \
      --enable-extended

# Newer binutils broke things on some vms/distros (i.e., linking against
# unknown relocs disabled by the following flag), so we need to go out of our
# way to produce "super compatible" binaries.
#
# See: https://github.com/rust-lang/rust/issues/34978
ENV CFLAGS_x86_64_unknown_linux_musl=-Wa,-mrelax-relocations=no

ENV SCRIPT \
      python2.7 ../x.py test --target x86_64-unknown-linux-musl && \
      python2.7 ../x.py dist --target x86_64-unknown-linux-musl
