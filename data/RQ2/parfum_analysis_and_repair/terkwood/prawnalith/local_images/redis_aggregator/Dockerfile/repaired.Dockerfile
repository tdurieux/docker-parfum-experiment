FROM prawnalith/local/rust

RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /prawnalith/services/redis_aggregator

RUN cargo install --path .

WORKDIR /data

ENTRYPOINT [ "redis_aggregator" ]
