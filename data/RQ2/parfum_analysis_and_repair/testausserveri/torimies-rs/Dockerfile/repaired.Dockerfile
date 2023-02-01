FROM rust:latest AS build

WORKDIR /app

COPY Cargo* ./

COPY src/main.rs ./src/

RUN cargo fetch

COPY . .

RUN cargo build --release --target-dir /usr/local/cargo

RUN cargo install diesel_cli --no-default-features --features "sqlite"

# Final image
FROM debian:latest

WORKDIR /app

COPY --from=build /usr/local/cargo/bin/diesel /app/

COPY --from=build /usr/local/cargo/release/torimies-rs /app/

RUN apt-get update && apt-get install --no-install-recommends sqlite3 --yes && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh ./

CMD ["bash", "entrypoint.sh"]