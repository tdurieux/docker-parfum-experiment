FROM ubuntu:18.04

COPY entrypoint.sh /entrypoint.sh

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get update && apt-get install --no-install-recommends -y git build-essential cmake binutils-aarch64-linux-gnu crossbuild-essential-arm64 pkg-config-aarch64-linux-gnu python3 wget libglib2.0-dev && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/entrypoint.sh"]
