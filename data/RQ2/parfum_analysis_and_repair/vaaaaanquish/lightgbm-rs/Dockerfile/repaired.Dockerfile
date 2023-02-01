FROM rust:1.49.0
RUN apt update && apt install --no-install-recommends -y cmake libclang-dev libc++-dev gcc-multilib && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
