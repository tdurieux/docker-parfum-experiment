FROM debian:bullseye

# Add required cross-compiler architectures
RUN dpkg --add-architecture arm64
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes make git curl gcc-aarch64-linux-gnu gcc gettext-base libsystemd-dev libsystemd-dev:arm64 && rm -rf /var/lib/apt/lists/*; # Install dependencies and cross compile toolchain
# The dockerfile currently assumes an amd64 build machine.


# Install the rust toolchain
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > sh.rustup.rs
RUN sh sh.rustup.rs -y --quiet
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add x86_64-unknown-linux-gnu

COPY ./ /workspace
COPY ./pkg/crossplatform/docker-entrypoint.sh /workspace

WORKDIR /workspace

RUN cargo fetch

ENTRYPOINT ["/usr/bin/env", "bash", "/workspace/docker-entrypoint.sh", "debian11", "bullseye"]
