FROM rust:latest
RUN apt-get update \
    && apt-get install --no-install-recommends -y libudev-dev libclang-dev lld \
    && rustup component add rustfmt && rm -rf /var/lib/apt/lists/*;
WORKDIR /srv
COPY . .
RUN cargo build --release \
    && mv target/release/zo-keeper . \
    && cargo clean \
    && mkdir -p target/release \
    && mv zo-keeper target/release
CMD ./scripts/heroku-docker-cmd.sh
