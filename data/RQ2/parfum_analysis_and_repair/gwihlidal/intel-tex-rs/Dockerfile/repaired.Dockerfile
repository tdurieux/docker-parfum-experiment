FROM rust:latest

RUN apt update \
 && apt install --no-install-recommends -y \
      clang \
 && apt autoremove -y \
 && apt autoclean \
 && apt clean \
 && apt autoremove && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/intel-tex

COPY examples examples
COPY src src
COPY vendor vendor
COPY build.rs .
COPY Cargo.toml .
COPY Cargo.lock .
COPY dependencies/ispc-v1.9.2-linux.tar.gz .

# Extract ISPC binary and install it
RUN tar -xvzf ispc-v1.9.2-linux.tar.gz \
 && cd ispc-v1.9.2-linux \
 && cp ./ispc /usr/local/bin/ispc \
 && chmod +x /usr/local/bin/ispc && rm ispc-v1.9.2-linux.tar.gz

RUN cargo build --release --all && cargo build --release --example main
RUN cargo run --release --example main

ENTRYPOINT ["/bin/bash"]