FROM ubuntu:focal
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y && apt-get install --no-install-recommends -y curl git build-essential cmake pkg-config libfreetype6-dev libexpat-dev && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly
ENV PATH="/root/.cargo/bin:${PATH}"
RUN git clone https://github.com/twilco/kosmonaut.git
WORKDIR kosmonaut
RUN cargo build

