FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
    bison \
    cmake \
    flex \
    g++ \
    git \
    libclang-5.0-dev \
    libelf-dev \
    llvm-5.0-dev \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

COPY build.sh /build.sh
ENTRYPOINT ["bash", "/build.sh"]
