FROM rust
# Install nmap first.
RUN apt-get update -qy && apt-get install --no-install-recommends -qy nmap && rm -rf /var/lib/apt/lists/*;
# Then install rustfmt and clippy for cargo.
RUN rustup component add rustfmt clippy