FROM ubuntu:jammy

# this is pretty broken, but is the current state of things I guess?
RUN apt-get update -qq && apt-get install --no-install-recommends curl build-essential pkg-config libssl3 libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root
ENV HOME=/root
RUN curl -f -sSL sh.rustup.rs >/tmp/rustup.sh && bash /tmp/rustup.sh -y
ENV PATH=${PATH}:${HOME}/.cargo/bin
RUN cargo install cargo-deb
