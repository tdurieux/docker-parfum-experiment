FROM rust:1-slim-bullseye

RUN apt-get update && apt-get install --no-install-recommends -y libudev-dev libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY Cargo.toml Cargo.lock ./
COPY src ./src

RUN cargo build --release

COPY beachside.so ./

EXPOSE 8080

CMD [ "./target/release/beachside" ]
