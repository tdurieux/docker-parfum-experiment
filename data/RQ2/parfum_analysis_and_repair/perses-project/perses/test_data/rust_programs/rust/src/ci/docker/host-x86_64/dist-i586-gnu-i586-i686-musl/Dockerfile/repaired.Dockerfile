FROM ubuntu:16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  g++-multilib \
  make \
  ninja-build \
  file \
  curl \
  ca-certificates \
  python3 \
  git \
  cmake \
  xz-utils \
  sudo \
  gdb \
  patch \
  libssl-dev \
  pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /build/
COPY scripts/musl.sh /build/
RUN CC=gcc CFLAGS="-m32 -Wa,-mrelax-relocations=no" \
    CXX=g++ CXXFLAGS="-m32 -Wa,-mrelax-relocations=no" \
    bash musl.sh i686 --target=i686 && \
    CC=gcc CFLAGS="-march=pentium -m32 -Wa,-mrelax-relocations=no" \
    CXX=g++ CXXFLAGS="-march=pentium -m32 -Wa,-mrelax-relocations=no" \
    bash musl.sh i586 --target=i586 && \
    rm -rf /build

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV RUST_CONFIGURE_ARGS \
      --musl-root-i586=/musl-i586 \
      --musl-root-i686=/musl-i686 \
      --disable-docs

# Newer binutils broke things on some vms/distros (i.e., linking against
# unknown relocs disabled by the following flag), so we need to go out of our
# way to produce "super compatible" binaries.
#
# See: https://github.com/rust-lang/rust/issues/34978
ENV CFLAGS_i686_unknown_linux_musl=-Wa,-mrelax-relocations=no
ENV CFLAGS_i586_unknown_linux_gnu=-Wa,-mrelax-relocations=no
ENV CFLAGS_i586_unknown_linux_musl=-Wa,-mrelax-relocations=no

ENV TARGETS=i586-unknown-linux-gnu,i686-unknown-linux-musl

ENV SCRIPT \
      python3 ../x.py --stage 2 test --host='' --target $TARGETS && \
      python3 ../x.py dist --host='' --target $TARGETS,i586-unknown-linux-musl
