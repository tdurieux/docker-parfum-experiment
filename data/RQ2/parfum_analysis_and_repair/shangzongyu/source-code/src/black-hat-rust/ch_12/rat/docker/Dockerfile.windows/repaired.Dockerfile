FROM rust:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y g++-mingw-w64-x86-64 && rm -rf /var/lib/apt/lists/*;

RUN rustup target add x86_64-pc-windows-gnu
RUN rustup toolchain install stable-x86_64-pc-windows-gnu

WORKDIR /app

CMD ["cargo", "build", "--target", "x86_64-pc-windows-gnu"]
