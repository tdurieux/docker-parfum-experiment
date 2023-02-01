FROM ubuntu:19.10


RUN apt update -y && apt install --no-install-recommends -y \
    cmake \
    git \
    gcc \
    g++ \
    libboost-all-dev \
    nlohmann-json3-dev \
    libfmt-dev \
    libgtest-dev && rm -rf /var/lib/apt/lists/*;

# RUN mkdir build && cd build && cmake .. && cmake --build . -j
