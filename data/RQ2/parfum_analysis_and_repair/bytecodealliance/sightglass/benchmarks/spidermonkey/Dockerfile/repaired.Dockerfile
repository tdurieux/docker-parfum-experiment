FROM ubuntu:20.04

RUN apt-get update
RUN apt-get -y --no-install-recommends install git python3 python3-pip python3-distutils curl sudo && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://sh.rustup.rs | bash -s - -y
ENV PATH=/root/.cargo/bin:$PATH

# Build SpiderMonkey itself.
WORKDIR /usr/src
RUN git clone https://github.com/tschneidereit/spidermonkey-wasi-embedding
WORKDIR /usr/src/spidermonkey-wasi-embedding
ENV DEBIAN_FRONTEND=noninteractive
RUN ./build-engine.sh

RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-14/wasi-sdk-14.0-linux.tar.gz
RUN tar zxvf wasi-sdk-14.0-linux.tar.gz && rm wasi-sdk-14.0-linux.tar.gz
RUN ln -s wasi-sdk-14.0 wasi-sdk

WORKDIR /usr/src
RUN mkdir benchmark && cd benchmark/
COPY runtime.cpp .
COPY sightglass.h .
COPY build.sh .
RUN ./build.sh

