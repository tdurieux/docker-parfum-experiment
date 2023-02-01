FROM rust as build

WORKDIR /build
COPY /src /build/src
COPY /dns /build/dns
COPY /dns-transport /build/dns-transport
COPY /man /build/man
COPY build.rs Cargo.toml /build/

RUN cargo build --release

FROM debian:buster-slim

RUN apt update && apt install --no-install-recommends -y libssl1.1 ca-certificates && apt clean all && rm -rf /var/lib/apt/lists/*;

COPY --from=build /build/target/release/dog /dog

ENTRYPOINT ["/dog"]
