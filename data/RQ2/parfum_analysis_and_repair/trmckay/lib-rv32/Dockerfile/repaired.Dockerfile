# This Dockerfile aims to emulate CI for local debugging.
# It's also useful if you want to test/develop but do not
# have a toolchain installed locally.

from ubuntu:latest

RUN \
    apt update && DEBIAN_FRONTEND="noninteractive" \
    apt --no-install-recommends install -y \
    git cargo make gcc-riscv64-unknown-elf binutils-riscv64-unknown-elf && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /repo
COPY . /repo

WORKDIR /repo
ENTRYPOINT ["make", "test"]
