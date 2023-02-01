FROM ubuntu:20.04

ENV TARGET_DIR='target'
WORKDIR /app

RUN apt-get update \
    && apt-get install --no-install-recommends -y libssl-dev ca-certificates \
    && chmod 777 /app \
    && mkdir /usr/share/nomad \
    && chmod 1000 /usr/share/nomad && rm -rf /var/lib/apt/lists/*;

COPY ${TARGET_DIR}/release/updater \
     ${TARGET_DIR}/release/relayer \
     ${TARGET_DIR}/release/watcher \
     ${TARGET_DIR}/release/processor \
     ${TARGET_DIR}/release/kathy \
     ${TARGET_DIR}/release/kms-cli \
     ${TARGET_DIR}/release/nomad-cli ./

USER 1000
CMD ["./watcher"]