FROM ghcr.io/plc-lang/rust-llvm:latest

RUN apt-get update \
    && apt-get install --no-install-recommends -y git iproute2 procps lsb-release && rm -rf /var/lib/apt/lists/*;
