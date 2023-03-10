FROM rust:latest as cargo-build

RUN apt-get update && apt-get install --no-install-recommends gcc-mingw-w64-x86-64 -y && rm -rf /var/lib/apt/lists/*;

RUN rustup target add x86_64-pc-windows-gnu

WORKDIR /usr/src/main

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, the build cache was invalidated\")}" > src/main.rs

RUN cargo build --release --target=x86_64-pc-windows-gnu

RUN rm -f target/x86_64-pc-windows-gnu/release/deps/snark-setup-operator*

COPY src ./src
COPY LICENSE .
COPY Cargo.lock .
COPY README.md .

RUN mkdir out
RUN cargo build --release --bin generate --target=x86_64-pc-windows-gnu && cp target/x86_64-pc-windows-gnu/release/generate.exe out/generate-windows.exe
RUN cargo build --release --bin contribute --target=x86_64-pc-windows-gnu && cp target/x86_64-pc-windows-gnu/release/contribute.exe out/contribute-windows.exe
RUN cargo build --release --bin generate --target=x86_64-pc-windows-gnu --no-default-features && cp target/x86_64-pc-windows-gnu/release/generate.exe out/generate-windows-noasm.exe
RUN cargo build --release --bin contribute --target=x86_64-pc-windows-gnu --no-default-features && cp target/x86_64-pc-windows-gnu/release/contribute.exe out/contribute-windows-noasm.exe