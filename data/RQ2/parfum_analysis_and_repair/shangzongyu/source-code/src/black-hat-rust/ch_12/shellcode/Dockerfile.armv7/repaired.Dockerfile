FROM rust:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y g++-arm-linux-gnueabihf libc6-dev-armhf-cross && rm -rf /var/lib/apt/lists/*;

RUN rustup default nightly
RUN rustup target add armv7-unknown-linux-gnueabihf

WORKDIR /app

ENV CARGO_TARGET_ARMV7_UNKNOWN_LINUX_GNUEABIHF_LINKER=arm-linux-gnueabihf-gcc \
    CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc \
    CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++

CMD ["make", "hello_world_armv7_docker"]
