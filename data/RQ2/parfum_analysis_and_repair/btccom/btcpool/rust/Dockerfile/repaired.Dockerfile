FROM ubuntu:18.04 as build
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl pkg-config libssl-dev clang gcc g++ cmake git && \
    curl https://sh.rustup.rs -sSf > install.sh && \
    chmod a+x install.sh && ./install.sh -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /work
COPY . /work/
RUN export PATH="$HOME/.cargo/bin:$PATH" && cargo build --release

FROM ubuntu:18.04

RUN apt update && apt install -y --no-install-recommends libssl && rm -rf /var/lib/apt/lists/*;
COPY --from=build /work/target/release/nodebridge /usr/bin/

ENTRYPOINT ["/usr/bin/nodebridge"]