FROM rust:1-slim AS builder

RUN apt update && apt install --no-install-recommends -y libclang-dev && rm -rf /var/lib/apt/lists/*;

COPY . /sources
WORKDIR /sources
RUN cargo build --release
RUN chown nobody:nogroup /sources/target/release/bin


FROM debian:bullseye-slim
COPY --from=builder /sources/target/release/bin /pastebin

USER nobody
EXPOSE 8000
ENTRYPOINT ["/pastebin", "0.0.0.0:8000"]
