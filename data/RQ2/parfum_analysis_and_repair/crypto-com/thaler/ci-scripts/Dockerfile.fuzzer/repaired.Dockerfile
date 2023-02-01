FROM rustlang/rust:nightly-buster
LABEL maintainer="Crypto.com"

RUN apt-get update && \
    apt-get install -y --no-install-recommends libudev-dev clang protobuf-compiler && \
    rm -rf /var/lib/apt/lists/*