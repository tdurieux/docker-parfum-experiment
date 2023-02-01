FROM ubuntu:16.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y git clang-format-6.0 build-essential device-tree-compiler libfdt-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /freedom-devicetree-tools
