FROM ubuntu:18.04

RUN apt-get -y update && apt-get -y --no-install-recommends install build-essential cmake llvm-6.0-dev libclang-6.0-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN useradd -m -p dev dev

USER dev
