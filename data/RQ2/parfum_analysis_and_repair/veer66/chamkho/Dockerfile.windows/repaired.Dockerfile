FROM rust
RUN apt-get update && apt-get upgrade && apt-get install --no-install-recommends -y gcc-mingw-w64 && rm -rf /var/lib/apt/lists/*;
RUN rustup target add x86_64-pc-windows-gnu