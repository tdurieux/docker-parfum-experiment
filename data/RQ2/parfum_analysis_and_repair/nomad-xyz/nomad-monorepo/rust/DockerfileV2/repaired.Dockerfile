FROM ubuntu:20.04

WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y libssl-dev ca-certificates \
    && chmod 777 /app \
    && mkdir /usr/share/nomad \
    && chmod 1000 /usr/share/nomad && rm -rf /var/lib/apt/lists/*;

COPY target/release/updater \
     target/release/relayer \
     target/release/watcher \
     target/release/processor \
     target/release/kathy \
     target/release/kms-cli \
     target/release/nomad-cli ./
COPY config ./config

USER 1000
CMD ["./watcher"]