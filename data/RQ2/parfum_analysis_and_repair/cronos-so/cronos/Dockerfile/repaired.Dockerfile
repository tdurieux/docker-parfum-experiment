# This Dockerfile provides a Linux-based environment, pre-installed with Solana dev tooling
# such as Rust, the Solana CLI, and the latest Soteria code scanner.
#
# You can pull the latest published image from Dockerhub (https://hub.docker.com/r/cronoslabs/dev)
# Or you can build an image from source using the Docker CLI:
#  ```sh
#  docker build -t cronoslabs/dev .
#  ```
#
# Note: When building Docker images on an M1 Mac, you should use the `--platform linux/amd64` flag.
#

FROM ubuntu:18.04

# Set dependency versions.
ENV SOLANA_VERSION=v1.10.25

# Configure path.
ENV HOME="/root"
ENV PATH="${HOME}/.cargo/bin:${PATH}"
ENV PATH="${HOME}/.local/share/solana/install/active_release/bin:${PATH}"
ENV PATH="${HOME}/soteria-linux-develop/bin/:${PATH}"

# Install base utilities.
RUN mkdir -p /workdir && \
    mkdir -p /tmp && \
    apt-get update && \
    apt-get upgrade && \
    apt-get install --no-install-recommends -y build-essential git curl wget jq pkg-config libssl-dev libudev-dev && rm -rf /var/lib/apt/lists/*;

# Move into root.
WORKDIR ${HOME}

# Install Rust.
RUN curl "https://sh.rustup.rs" -sfo rustup.sh && \
    sh rustup.sh -y && \
    rustup component add rustfmt clippy

# Install Solana.
RUN sh -c "$(curl -sSfL https://release.solana.com/${SOLANA_VERSION}/install)"

# Install Soteria.
RUN sh -c "$( curl -f -k https://supercompiler.xyz/install)" -f

# Set workdir.
WORKDIR /workdir
