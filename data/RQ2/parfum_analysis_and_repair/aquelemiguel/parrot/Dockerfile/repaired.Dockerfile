# Build image
# Necessary dependencies to build Parrot
FROM rust:slim-bullseye as build

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential autoconf automake libtool libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR "/parrot"

# Cache cargo build dependencies by creating a dummy source
RUN mkdir src
RUN echo "fn main() {}" > src/main.rs
COPY Cargo.toml ./
RUN cargo build --release

COPY . .
RUN cargo build --release

# Release image
# Necessary dependencies to run Parrot
FROM debian:bullseye-slim

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -U yt-dlp

COPY --from=build /parrot/target/release/parrot .

CMD ["./parrot"]
