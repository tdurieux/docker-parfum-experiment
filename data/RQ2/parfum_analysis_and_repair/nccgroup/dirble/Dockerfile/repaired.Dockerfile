FROM rust:latest as cargo-build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --no-install-recommends libssl-dev -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/dirble
COPY . .

RUN cargo build --release

FROM debian:stretch

WORKDIR /home/dirble

COPY --from=cargo-build /usr/src/dirble/target/release/dirble .
COPY --from=cargo-build /usr/src/dirble/dirble_wordlist.txt .
COPY --from=cargo-build /usr/src/dirble/extensions/* extensions/

RUN apt-get update && apt-get install --no-install-recommends -y \
    libcurl4-openssl-dev \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["./dirble"]
CMD []
