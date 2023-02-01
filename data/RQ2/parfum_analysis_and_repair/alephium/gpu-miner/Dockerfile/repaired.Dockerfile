FROM nvidia/cuda:11.0-devel-ubuntu20.04 AS builder

WORKDIR /src

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install cmake tzdata && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/conan-io/conan/releases/latest/download/conan-ubuntu-64.deb -o out.deb && \
    DEBIAN_FRONTEND=sudo apt-get --no-install-recommends -y install ./out.deb && rm -rf /var/lib/apt/lists/*;

COPY ./ ./
RUN ./make.sh

FROM nvidia/cuda:11.0-base

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /src/bin/gpu-miner /gpu-miner

USER root

ENTRYPOINT ["/gpu-miner"]
