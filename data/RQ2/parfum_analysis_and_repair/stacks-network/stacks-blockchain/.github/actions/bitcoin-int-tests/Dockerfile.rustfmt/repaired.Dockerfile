FROM rust:bullseye

WORKDIR /src

COPY ./rust-toolchain .
COPY ./Cargo.toml .

RUN rustup component add rustfmt

COPY . .

RUN cargo fmt --all -- --check