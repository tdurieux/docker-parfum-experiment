FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install --no-install-recommends -y build-essential curl && rm -rf /var/lib/apt/lists/*;

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain=1.57.0

ENV PATH=/root/.cargo/bin:$PATH

ADD . /code/fuser/
