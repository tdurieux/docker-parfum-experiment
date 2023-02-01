FROM rustlang/rust:nightly-buster AS build

RUN apt-get update && apt-get install --no-install-recommends -y musl-tools && rm -rf /var/lib/apt/lists/*;

RUN rustup --version
RUN rustup target add x86_64-unknown-linux-musl

RUN rustc --version && \
    rustup --version && \
    cargo --version

WORKDIR /app
COPY . /app
RUN cargo clean && cargo build --release --target x86_64-unknown-linux-musl
RUN strip ./target/x86_64-unknown-linux-musl/release/vigil

FROM scratch

WORKDIR /usr/src/vigil

COPY ./res/assets/ ./res/assets/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /app/target/x86_64-unknown-linux-musl/release/vigil /usr/local/bin/vigil

CMD [ "vigil", "-c", "/etc/vigil.cfg" ]

EXPOSE 8080
