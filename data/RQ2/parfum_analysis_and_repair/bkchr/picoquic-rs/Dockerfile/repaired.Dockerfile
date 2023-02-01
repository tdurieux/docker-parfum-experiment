FROM rust:latest

RUN apt-get update && apt-get -y --no-install-recommends install openssl libclang-dev clang && rm -rf /var/lib/apt/lists/*;
