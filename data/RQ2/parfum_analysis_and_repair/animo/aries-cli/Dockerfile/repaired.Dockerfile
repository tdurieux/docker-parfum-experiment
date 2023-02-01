FROM rust:1.61.0

RUN apt-get update -y && apt-get install --no-install-recommends libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev -y && rm -rf /var/lib/apt/lists/*;

COPY ./crates ./crates
COPY ./Cargo.toml ./Cargo.lock ./

RUN cargo build --release --locked

# Default command, overridden in other places
CMD ./target/release/agent-cli --version

