FROM rust:1.37
LABEL Description="Rust compile env for Linux + Windows (cross)"

RUN apt update
RUN apt install -y build-essential mingw-w64 gcc-aarch64-linux-gnu gcc-arm-linux-gnueabihf

RUN rustup target add x86_64-pc-windows-gnu
RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add armv7-unknown-linux-gnueabihf

# Append the linker to the cargo config for Windows cross compile
RUN echo "[target.x86_64-pc-windows-gnu]" >> /usr/local/cargo/config && \
    echo "linker = '/usr/bin/x86_64-w64-mingw32-gcc'" >> /usr/local/cargo/config

RUN echo "[target.aarch64-unknown-linux-gnu]" >> /usr/local/cargo/config && \
    echo "linker = '/usr/bin/aarch64-linux-gnu-gcc'" >> /usr/local/cargo/config

RUN echo "[target.armv7-unknown-linux-gnueabihf]" >> /usr/local/cargo/config && \
    echo "linker = '/usr/bin/arm-linux-gnueabihf-gcc-5'" >> /usr/local/cargo/config

ENV CC_aarch64_unknown_linux_gnu="aarch64-linux-gnu-gcc" 
ENV CC_armv7_unknown_linux_gnueabhihf="arm-linux-gnueabihf-gcc-5"
