FROM rust:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y g++ libc6-dev make && rm -rf /var/lib/apt/lists/*;

RUN rustup default nightly

WORKDIR /app

CMD ["make", "hello_world_x86_64_docker"]
