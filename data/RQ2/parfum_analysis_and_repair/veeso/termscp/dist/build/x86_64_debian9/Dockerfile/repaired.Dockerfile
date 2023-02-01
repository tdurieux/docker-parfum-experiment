FROM debian:stretch

ARG branch
ENV branch=$branch
WORKDIR /usr/src/
# Install dependencies
RUN apt update && apt install --no-install-recommends -y \
  git \
  gcc \
  pkg-config \
  libssl-dev \
  libssh2-1-dev \
  libdbus-1-dev \
  bash \
  curl && rm -rf /var/lib/apt/lists/*;

# Install rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /tmp/rust.sh && \
  chmod +x /tmp/rust.sh && \
  /tmp/rust.sh -y
# Clone repository
RUN git clone --branch $branch https://github.com/veeso/termscp.git
# Set workdir to termscp
WORKDIR /usr/src/termscp/
# Install cargo deb
RUN . $HOME/.cargo/env && cargo install cargo-deb
# Build for x86_64
RUN . $HOME/.cargo/env && cargo build --release
# Build pkgs
RUN . $HOME/.cargo/env && cargo deb

CMD ["bash"]
