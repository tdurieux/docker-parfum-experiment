FROM rust:latest as builder

WORKDIR /build
COPY . .

RUN apt-get update
RUN apt-get install --no-install-recommends cmake clang llvm gcc -y && rm -rf /var/lib/apt/lists/*;
RUN cd /build && cargo build --release

FROM debian:bookworm-20211011-slim
WORKDIR /app

RUN rm /var/lib/apt/lists/* -fv
RUN apt-get update
RUN apt install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libc6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /build/target/release/axon /app/axon
COPY --from=builder /build/devtools /app/devtools

CMD ./axon -c=/app/devtools/chain/config.toml -g=/app/devtools/chain/genesis.json


