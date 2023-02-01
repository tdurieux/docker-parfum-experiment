FROM rust AS builder

RUN apt-get update && apt-get install --no-install-recommends musl-tools -y && rm -rf /var/lib/apt/lists/*;
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src
COPY Cargo.toml Cargo.lock ./

RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/fesghel*

ADD . ./

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

# Bundle Stage
FROM scratch

WORKDIR /fesghel
COPY --from=builder /usr/src/target/x86_64-unknown-linux-musl/release/fesghel .
COPY ./config ./config
CMD ["./fesghel"]
