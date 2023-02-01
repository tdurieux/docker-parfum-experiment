FROM ubuntu:21.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y wget git curl software-properties-common golang && rm -rf /var/lib/apt/lists/*;

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
ENV PATH=/root/.cargo/bin:$PATH
RUN rustup target add wasm32-wasi

RUN curl https://raw.githubusercontent.com/second-state/rustwasmc/master/installer/init.sh -sSf | sh

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install wasmedge-core && npm cache clean --force;

RUN mkdir -p /root/examples
WORKDIR /root/examples
RUN wget https://github.com/WasmEdge/WasmEdge/raw/master/examples/wasm/hello.wasm &&\
    wget https://github.com/WasmEdge/WasmEdge/raw/master/examples/js/qjs.wasm &&\
    wget https://github.com/WasmEdge/WasmEdge/raw/master/examples/js/hello.js &&\
    wget https://github.com/WasmEdge/WasmEdge/raw/master/examples/js/repl.js

ENTRYPOINT ["/bin/bash", "-l"]
