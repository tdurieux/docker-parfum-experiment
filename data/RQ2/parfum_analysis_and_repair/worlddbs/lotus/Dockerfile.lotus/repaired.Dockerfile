FROM golang:1.15.6 AS builder-deps
MAINTAINER Lotus Development Team

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates build-essential clang ocl-icd-opencl-dev ocl-icd-libopencl1 jq libhwloc-dev && rm -rf /var/lib/apt/lists/*;

ARG RUST_VERSION=nightly
ENV XDG_CACHE_HOME="/tmp"

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN wget "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;


FROM builder-deps AS builder-local
MAINTAINER Lotus Development Team

COPY ./ /opt/filecoin
WORKDIR /opt/filecoin
RUN make clean deps


FROM builder-local AS builder
MAINTAINER Lotus Development Team

WORKDIR /opt/filecoin

ARG RUSTFLAGS=""
ARG GOFLAGS=""

RUN make deps lotus lotus-miner lotus-worker lotus-shed lotus-chainwatch lotus-stats


FROM ubuntu:20.04 AS base
MAINTAINER Lotus Development Team

# Base resources
COPY --from=builder /etc/ssl/certs                           /etc/ssl/certs
COPY --from=builder /lib/x86_64-linux-gnu/libdl.so.2         /lib/
COPY --from=builder /lib/x86_64-linux-gnu/librt.so.1         /lib/
COPY --from=builder /lib/x86_64-linux-gnu/libgcc_s.so.1      /lib/
COPY --from=builder /lib/x86_64-linux-gnu/libutil.so.1       /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libltdl.so.7   /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libnuma.so.1   /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libhwloc.so.5  /lib/
COPY --from=builder /usr/lib/x86_64-linux-gnu/libOpenCL.so.1 /lib/

RUN useradd -r -u 532 -U fc


FROM base AS lotus
MAINTAINER Lotus Development Team

COPY --from=builder /opt/filecoin/lotus      /usr/local/bin/
COPY --from=builder /opt/filecoin/lotus-shed /usr/local/bin/

ENV FILECOIN_PARAMETER_CACHE /var/tmp/filecoin-proof-parameters
ENV LOTUS_PATH /var/lib/lotus

RUN mkdir /var/lib/lotus /var/tmp/filecoin-proof-parameters && chown fc /var/lib/lotus /var/tmp/filecoin-proof-parameters

USER fc

ENTRYPOINT ["/usr/local/bin/lotus"]

CMD ["-help"]
