FROM emscripten/emsdk:3.1.14
WORKDIR /
ARG DEBIAN_FRONTEND=noninteractive

COPY common.sh lib.sh /
RUN /common.sh

COPY cmake.sh /
RUN /cmake.sh

COPY xargo.sh /
RUN /xargo.sh

RUN apt-get update && apt-get install -y --assume-yes --no-install-recommends \
  libxml2 \
  python && rm -rf /var/lib/apt/lists/*;

ENV CARGO_TARGET_WASM32_UNKNOWN_EMSCRIPTEN_RUNNER=node \
  BINDGEN_EXTRA_CLANG_ARGS_wasm32_unknown_emscripten="--sysroot=/emsdk/upstream/emscripten/cache/sysroot"
