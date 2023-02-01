# Build image
FROM ekidd/rust-musl-builder:1.57.0 AS build

COPY Cargo.toml Cargo.lock /tmp/
COPY src/ /tmp/src/

RUN cargo install --path /tmp && strip /home/rust/.cargo/bin/azi

# Runtime image