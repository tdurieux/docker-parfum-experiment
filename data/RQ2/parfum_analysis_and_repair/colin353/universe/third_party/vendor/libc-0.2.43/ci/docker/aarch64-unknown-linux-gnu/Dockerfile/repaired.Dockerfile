FROM ubuntu:17.10
RUN apt-get update && apt-get install -y --no-install-recommends \
  gcc libc6-dev ca-certificates \
  gcc-aarch64-linux-gnu libc6-dev-arm64-cross qemu-user && rm -rf /var/lib/apt/lists/*;
ENV CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_LINKER=aarch64-linux-gnu-gcc \
    CARGO_TARGET_AARCH64_UNKNOWN_LINUX_GNU_RUNNER="qemu-aarch64 -L /usr/aarch64-linux-gnu" \
    PATH=$PATH:/rust/bin
