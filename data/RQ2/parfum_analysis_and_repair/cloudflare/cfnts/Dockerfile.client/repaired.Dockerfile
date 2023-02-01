FROM rust:1.38.0-stretch

RUN apt-get update && apt-get install --no-install-recommends -y prometheus && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN cargo build --release

CMD ["./scripts/run_client.sh"]
