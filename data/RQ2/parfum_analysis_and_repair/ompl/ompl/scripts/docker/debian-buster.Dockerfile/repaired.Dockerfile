FROM debian:buster
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        libboost-filesystem-dev \
        libboost-program-options-dev \
        libboost-serialization-dev \
        libboost-system-dev \
        libboost-test-dev \
        libeigen3-dev \
        libflann-dev \
        libode-dev \
        pkg-config && rm -rf /var/lib/apt/lists/*;
COPY . /root/ompl
WORKDIR /root/ompl/build
