# STAGE-1: Build frugalos binary
FROM rust:slim

ARG FRUGALOS_VERSION

RUN apt update && apt install --no-install-recommends -y gcc automake libtool git make patch curl && rm -rf /var/lib/apt/lists/*;

RUN cargo install frugalos --version $FRUGALOS_VERSION


# STAGE-2: Copy the built binary
FROM debian

COPY --from=0 /usr/local/cargo/bin/frugalos /bin/frugalos
ENTRYPOINT ["/bin/frugalos"]
CMD ["--help"]
