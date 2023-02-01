FROM rust:slim AS builder

RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev pkg-config libsystemd-dev && rm -rf /var/lib/apt/lists/*;
COPY . /logram
WORKDIR /logram
RUN cargo build --release --features=bin_core,ls_counter,ls_filesystem,ls_journald,ls_docker

FROM debian:stable-slim

COPY --from=builder /logram/target/release/logram /logram/logram

ENTRYPOINT [ "/logram/logram" ]
CMD [ "help" ]
