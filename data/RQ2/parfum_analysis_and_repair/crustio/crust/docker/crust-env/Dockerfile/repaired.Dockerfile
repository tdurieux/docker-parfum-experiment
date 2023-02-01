# Build crust env image
FROM rust:latest

ARG TOOLCHAIN
ENV RUSTUP_TOOLCHAIN ${TOOLCHAIN:-nightly-2021-01-11}
RUN apt-get update && apt-get -y --no-install-recommends install lsb-release wget software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN wget https://apt.llvm.org/llvm.sh
RUN chmod +x llvm.sh
RUN ./llvm.sh 10
RUN rustup toolchain install ${RUSTUP_TOOLCHAIN}
RUN rustup update stable
RUN rustup target add wasm32-unknown-unknown --toolchain ${RUSTUP_TOOLCHAIN}
RUN rustup default ${RUSTUP_TOOLCHAIN}
RUN rustc -vV