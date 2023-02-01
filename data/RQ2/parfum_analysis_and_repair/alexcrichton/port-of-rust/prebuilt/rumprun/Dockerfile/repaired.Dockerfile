FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y curl file g++ git make zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/rumpkernel/rumprun
WORKDIR /rumprun
RUN git reset --hard 39a97f37a85e44c69b662f6b97b688fbe892603b
RUN git submodule update --init
RUN CC=cc ./build-rr.sh -d /usr/local hw
WORKDIR /

FROM ubuntu:16.04
COPY --from=0 /usr/local /usr/local
