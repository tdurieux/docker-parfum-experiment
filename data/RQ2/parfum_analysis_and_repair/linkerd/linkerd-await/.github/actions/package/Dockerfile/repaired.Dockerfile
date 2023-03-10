ARG BASE_IMAGE=rust:1.60.0-buster
FROM $BASE_IMAGE
WORKDIR /linkerd

RUN apt-get update && \
    apt-get install --no-install-recommends -y jq && \
    apt-get install --no-install-recommends -y musl-tools docker.io && \
    apt-get install --no-install-recommends -y binutils-x86-64-linux-gnu binutils-aarch64-linux-gnu binutils-arm-linux-gnueabihf && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

RUN cargo install cross
