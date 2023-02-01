FROM rust:bullseye

RUN cargo install -f cargo-deb --debug --version 1.30.0

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install --no-install-recommends -y cryptsetup pkg-config libclang-dev libcryptsetup-dev && mkdir -p /build/fido2luks && rm -rf /var/lib/apt/lists/*;

WORKDIR /build/fido2luks

ENV CARGO_TARGET_DIR=/build/fido2luks/target

RUN cargo install fido2luks -f

CMD bash -xc 'cp -rf /code/* /build/fido2luks && cargo-deb && cp target/debian/*.deb /out'
