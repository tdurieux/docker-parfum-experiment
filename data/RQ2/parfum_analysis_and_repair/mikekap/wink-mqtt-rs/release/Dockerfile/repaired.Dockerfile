FROM ubuntu:20.04

WORKDIR /tmp/

RUN echo 2021-03-21
RUN apt update && apt install --no-install-recommends -y build-essential curl wget && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://musl.cc/arm-linux-musleabi-cross.tgz && tar -zxvf arm-linux-musleabi-cross.tgz --strip-components 1 -C /usr/local/ && rm arm-linux-musleabi-cross.tgz
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN rustup toolchain install nightly && rustup default nightly-x86_64-unknown-linux-gnu && rustup target add armv5te-unknown-linux-musleabi
ENV TARGET_CC=arm-linux-musleabi-gcc
