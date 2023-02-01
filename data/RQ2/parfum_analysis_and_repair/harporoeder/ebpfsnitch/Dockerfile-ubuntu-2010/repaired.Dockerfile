# Used to ensure the build works in a clean Ubuntu 20.10 environment
# This Dockerfile will fail if not run on a Linux 5.8 kernel

FROM ubuntu:20.10

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    cmake \
    clang \
    libboost-all-dev \
    libspdlog-dev \
    libmnl-dev \
    linux-tools-common \
    nlohmann-json3-dev \
    libbpf-dev \
    linux-tools-generic \
    conntrack \
    python3 \
    python3-pyqt5 \
    libnfnetlink-dev \
    xxd \
    linux-tools-5.8.0-44-generic && rm -rf /var/lib/apt/lists/*;

ADD http://mirrors.kernel.org/ubuntu/pool/universe/libn/libnetfilter-queue/libnetfilter-queue-dev_1.0.5-2_amd64.deb /tmp/
ADD http://mirrors.kernel.org/ubuntu/pool/universe/libn/libnetfilter-queue/libnetfilter-queue1_1.0.5-2_amd64.deb /tmp/

RUN dpkg --install /tmp/libnetfilter-queue1_1.0.5-2_amd64.deb && \
    dpkg --install /tmp/libnetfilter-queue-dev_1.0.5-2_amd64.deb

WORKDIR /app

COPY . .

RUN mkdir build && cd build && cmake .. && make
