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
  libssl-dev \
  pkg-config && rm -rf /var/lib/apt/lists/*;

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

ENV RUST_CONFIGURE_ARGS --build=x86_64-unknown-linux-gnu --set rust.ignore-git=false
ENV SCRIPT python3 ../x.py --stage 2 test distcheck
ENV DIST_SRC 1

# The purpose of this builder is to test that we can `./x.py --stage 2 test` successfully
# from a tarball, not to test LLVM/rustc's own set of assertions. These cause a
# significant hit to CI compile time (over a half hour as observed in #61185),
# so disable assertions for this builder.
ENV NO_LLVM_ASSERTIONS=1
ENV NO_DEBUG_ASSERTIONS=1
