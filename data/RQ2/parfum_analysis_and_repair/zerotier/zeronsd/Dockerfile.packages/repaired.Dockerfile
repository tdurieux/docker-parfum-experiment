FROM debian:latest as rustenv

RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install curl pkg-config build-essential ca-certificates libc6-dev -y && apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL sh.rustup.rs >/usr/local/bin/rustup-dl && chmod +x /usr/local/bin/rustup-dl && /usr/local/bin/rustup-dl -y --default-toolchain stable

FROM rustenv as buildenv

RUN . /root/.cargo/env && cargo install cargo-deb
