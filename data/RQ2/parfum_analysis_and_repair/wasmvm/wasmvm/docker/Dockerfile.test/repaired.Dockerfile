FROM ubuntu:focal

RUN apt update \
    && DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y gcc g++ cmake binutils git astyle ninja-build python3 valgrind \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root

CMD ["bash"]