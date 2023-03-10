FROM ubuntu:20.04

# Add packages for EH build
RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake \
    gcc \
    g++ \
    libbz2-dev \
    libcurl4-openssl-dev \
    liblzma-dev \
    libssl-dev \
    make \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

