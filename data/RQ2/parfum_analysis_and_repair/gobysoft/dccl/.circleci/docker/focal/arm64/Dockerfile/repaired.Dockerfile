FROM gobysoft/dccl-ubuntu-build-base:20.04.1

# Overwrite non-multiarch packages
RUN apt-get update && \
    apt-get -y --no-install-recommends install libcrypto++-dev:arm64 && \
    rm -rf /var/lib/apt/lists/*
