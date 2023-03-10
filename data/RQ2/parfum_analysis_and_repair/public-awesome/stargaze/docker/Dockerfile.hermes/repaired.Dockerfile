# informalsystems/hermes image
#
# Used for running hermes in docker containers
#
# Usage:
#   docker build . --build-arg TAG=v0.13.0 -t publicawesome/hermes:0.13.0 -f docker/Dockerfile.hermes

FROM rust:1.59-buster AS build-env

ARG TAG
WORKDIR /root

RUN git clone https://github.com/informalsystems/ibc-rs
RUN cd ibc-rs && git checkout $TAG && cargo build --release


FROM debian:buster-slim
LABEL maintainer="hello@informal.systems"
RUN apt update && apt install --no-install-recommends curl jq -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /home/hermes
ENTRYPOINT ["/usr/bin/hermes"]

COPY --chown=0:0 --from=build-env /usr/lib/x86_64-linux-gnu/libssl.so.1.1 /usr/lib/x86_64-linux-gnu/libssl.so.1.1
COPY --chown=0:0 --from=build-env /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1
COPY --chown=0:0 --from=build-env /root/ibc-rs/target/release/hermes /usr/bin/hermes
