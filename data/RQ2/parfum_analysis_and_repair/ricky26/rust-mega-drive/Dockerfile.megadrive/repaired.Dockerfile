FROM rust-m68k:latest
MAINTAINER rickytaylor26@gmail.com
MAINTAINER rein@vantveer.me

# Copy over all files
COPY . /rust-mega-drive

# Log the versions in use
RUN rustc --version
RUN cargo --version

# Build the rust-mega-drive crate
WORKDIR /rust-mega-drive
ENV MEGADRIVE_HOME=/rust-mega-drive/share
ENV RUSTUP_TOOLCHAIN=m68k
ENV LLVM_CONFIG=/llvm-m68k/bin/llvm-config
RUN cargo tree
RUN cargo build --release

# Install the megadrive cargo command
WORKDIR /rust-mega-drive/tools/cargo-megadrive
RUN cargo install --path=.