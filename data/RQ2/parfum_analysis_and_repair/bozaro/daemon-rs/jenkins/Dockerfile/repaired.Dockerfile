FROM rust:1.28-stretch

RUN apt-get update
RUN apt-get install --no-install-recommends -y git curl && rm -rf /var/lib/apt/lists/*;
RUN rustup target add i686-pc-windows-gnu
RUN rustup target add x86_64-pc-windows-gnu
RUN apt-get install --no-install-recommends -y gcc-mingw-w64 && rm -rf /var/lib/apt/lists/*;

COPY cargo.config /.cargo/config
COPY . /root/test/
WORKDIR /root/test/

CMD ["/bin/bash"]
