FROM debian:10
RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake \
    make \
    ninja-build && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    googletest \
    libboost-all-dev \
    nlohmann-json3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    clang-6.0 \
    llvm-6.0 && rm -rf /var/lib/apt/lists/*;
