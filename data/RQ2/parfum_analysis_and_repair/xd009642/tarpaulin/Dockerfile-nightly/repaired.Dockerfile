FROM rustlang/rust:nightly as builder

WORKDIR /opt/tarpaulin

RUN env USER=root cargo init .

COPY Cargo.toml .
COPY Cargo.lock .
COPY build.rs .

RUN mkdir .cargo
RUN cargo vendor > .cargo/config

COPY src /opt/tarpaulin/src

RUN cd /opt/tarpaulin/ && \
    cargo install --locked --path . && \
    rm -rf /opt/tarpaulin/ && \
    rm -rf /usr/local/cargo/registry/

FROM rustlang/rust:nightly

COPY --from=builder /usr/local/cargo/bin/cargo-tarpaulin /usr/local/cargo/bin/cargo-tarpaulin

WORKDIR /volume

CMD cargo build && cargo tarpaulin