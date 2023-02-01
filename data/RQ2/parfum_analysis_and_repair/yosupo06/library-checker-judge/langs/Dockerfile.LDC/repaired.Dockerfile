FROM ekidd/rust-musl-builder:latest as init-builder
COPY --chown=rust:rust init .
RUN cargo build --release

FROM ubuntu:22.04 as builder

RUN apt-get update
RUN apt-get install --no-install-recommends -y wget xz-utils && rm -rf /var/lib/apt/lists/*;
RUN wget https://github.com/ldc-developers/ldc/releases/download/v1.29.0/ldc2-1.29.0-linux-x86_64.tar.xz
RUN tar -xf ldc2-1.29.0-linux-x86_64.tar.xz -C /opt && rm ldc2-1.29.0-linux-x86_64.tar.xz

FROM ubuntu:22.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y libxml2 gcc && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /opt/ldc2-1.29.0-linux-x86_64/ /opt/ldc2-1.29.0-linux-x86_64/

ENV PATH $PATH:/opt/ldc2-1.29.0-linux-x86_64/bin

COPY --from=init-builder /home/rust/src/target/x86_64-unknown-linux-musl/release/library-checker-init /usr/bin
