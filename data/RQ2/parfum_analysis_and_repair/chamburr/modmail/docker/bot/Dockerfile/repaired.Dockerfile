FROM rust:1.60-slim-buster AS builder

RUN apt update && apt install --no-install-recommends -y musl-dev libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN cargo install diesel_cli --no-default-features --features "postgres"

WORKDIR /build

RUN cp /usr/local/cargo/bin/diesel ./

FROM python:3.10-slim-buster

RUN apt update && apt install --no-install-recommends -y dumb-init git gcc netcat libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./

RUN pip3 install --no-cache-dir -r requirements.txt

RUN mkdir logs

COPY --from=builder /build ./bin

COPY docker/entrypoint.sh ./bin/
COPY main.py worker.py ./
COPY classes ./classes
COPY cogs ./cogs
COPY migrations ./migrations
COPY scripts ./scripts
COPY utils ./utils

ENV PATH="/app/bin:${PATH}"

EXPOSE 6002

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["./bin/entrypoint.sh"]
