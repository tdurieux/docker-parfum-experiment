FROM rust:slim AS build
WORKDIR /usr/src/staccato
RUN apt-get update \
    && apt-get install --no-install-recommends -y musl-tools \
    && rustup target add x86_64-unknown-linux-musl && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN cargo build --release --target=x86_64-unknown-linux-musl \
    && strip --strip-debug target/x86_64-unknown-linux-musl/release/st

FROM scratch
COPY --from=build /usr/src/staccato/target/x86_64-unknown-linux-musl/release/st /bin/st
ENTRYPOINT ["/bin/st"]
CMD ["--help"]
