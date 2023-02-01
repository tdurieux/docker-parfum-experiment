FROM rust:latest

WORKDIR /src/blockstack-core

RUN apt-get update
RUN apt-get install --no-install-recommends valgrind heaptrack -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends less && rm -rf /var/lib/apt/lists/*;

RUN rustup install stable

COPY . .

RUN cargo test --no-run

CMD ["bash"]
