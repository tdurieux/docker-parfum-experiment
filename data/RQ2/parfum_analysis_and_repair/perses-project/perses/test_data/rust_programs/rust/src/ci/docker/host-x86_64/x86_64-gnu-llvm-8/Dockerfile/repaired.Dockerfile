FROM ubuntu:18.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  g++ \
  g++-arm-linux-gnueabi \
  make \
  ninja-build \
  file \
  curl \
  ca-certificates \
  python2.7 \
  git \
  cmake \
  sudo \
  gdb \
  llvm-8-tools \
  libedit-dev \
  libssl-dev \
  pkg-config \
  zlib1g-dev \
  xz-utils \
  nodejs && rm -rf /var/lib/apt/lists/*;

COPY scripts/sccache.sh /scripts/
RUN sh /scripts/sccache.sh

# using llvm-link-shared due to libffi issues -- see #34486
ENV RUST_CONFIGURE_ARGS \
      --build=x86_64-unknown-linux-gnu \
      --llvm-root=/usr/lib/llvm-8 \
      --enable-llvm-link-shared \
      --set rust.thin-lto-import-instr-limit=10

ENV SCRIPT python2.7 ../x.py --stage 2 test --exclude src/tools/tidy && \
           # Run the `mir-opt` tests again but this time for a 32-bit target.
           # This enforces that tests using `// EMIT_MIR_FOR_EACH_BIT_WIDTH` have
           # both 32-bit and 64-bit outputs updated by the PR author, before
           # the PR is approved and tested for merging.
           # It will also detect tests lacking `// EMIT_MIR_FOR_EACH_BIT_WIDTH`,
           # despite having different output on 32-bit vs 64-bit targets.
           #
           # HACK(eddyb) `armv5te` is used (not `i686`) to support older LLVM than LLVM 9:
           # https://github.com/rust-lang/compiler-builtins/pull/311#issuecomment-612270089.
           # This also requires `--pass=build` because we can't execute the tests
           # on the `x86_64` host when they're built as `armv5te` binaries.
           # (we're only interested in the MIR output, so this doesn't matter)
           python2.7 ../x.py --stage 2 test src/test/mir-opt --pass=build \
                             --host='' --target=armv5te-unknown-linux-gnueabi && \
           # Run the UI test suite again, but in `--pass=check` mode
           #
           # This is intended to make sure that both `--pass=check` continues to
           # work.
           #
           # FIXME: We ideally want to test this in 32-bit mode, but currently
           # (due to the LLVM problems mentioned above) that isn't readily
           # possible.
           python2.7 ../x.py --stage 2 test src/test/ui --pass=check && \
           # Run tidy at the very end, after all the other tests.
           python2.7 ../x.py --stage 2 test src/tools/tidy

# The purpose of this container isn't to test with debug assertions and
# this is run on all PRs, so let's get speedier builds by disabling these extra
# checks.
ENV NO_DEBUG_ASSERTIONS=1
ENV NO_LLVM_ASSERTIONS=1
