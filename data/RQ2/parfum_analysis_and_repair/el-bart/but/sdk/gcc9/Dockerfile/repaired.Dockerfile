FROM debian:11
RUN apt-get update && apt-get dist-upgrade -y

RUN apt-get update && apt-get install --no-install-recommends -y \
    cmake \
    make \
    ninja-build && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    googletest \
    libboost-all-dev \
    nlohmann-json3-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y g++-9 && rm -rf /var/lib/apt/lists/*;
