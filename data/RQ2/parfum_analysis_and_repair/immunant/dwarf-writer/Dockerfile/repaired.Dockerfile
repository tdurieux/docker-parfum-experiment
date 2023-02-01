FROM ubuntu:20.04
ENV PATH="/root/.cargo/bin:${PATH}"
RUN apt update && apt install --no-install-recommends -y curl build-essential && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain stable -y
RUN rustup update && rustup toolchain install stable
COPY . /root/src
WORKDIR /root/src
RUN cargo build --release

FROM ubuntu:20.04
COPY --from=0 /root/src/target/release/dwarf-writer /usr/local/bin/dwarf-writer
RUN apt update && apt install --no-install-recommends -y binutils-multiarch && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["/usr/local/bin/dwarf-writer"]
