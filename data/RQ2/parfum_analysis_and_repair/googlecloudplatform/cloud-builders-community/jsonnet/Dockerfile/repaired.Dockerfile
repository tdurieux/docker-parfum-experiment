FROM ubuntu:xenial

RUN \
    apt update -y && \
    apt -y --no-install-recommends install build-essential git && \
    git clone https://github.com/google/jsonnet.git && \
    cd jsonnet && \
    make && \
    ./jsonnet --help && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/jsonnet/jsonnet"]
