FROM ubuntu:16.04

RUN mkdir -p /opt/horizon
WORKDIR /opt/horizon
VOLUME ["/opt/horizon"]
EXPOSE 8000

# horizon configuration is done via environment variables
#
# available configuration at:
# https://github.com/kinecosystem/go/blob/horizon-v0.12.3/services/horizon/main.go#L29
ENV DATABASE_URL= \
    HORIZON_DB_MAX_OPEN_CONNECTIONS= \
    STELLAR_CORE_DATABASE_URL= \
    STELLAR_CORE_URL= \
    LOG_LEVEL= \
    INGEST= \
    PER_HOUR_RATE_LIMIT= \
    NETWORK_PASSPHRASE= \
    FRIENDBOT_SECRET= \
    FRIENDBOT_URL= \
    CURSOR_NAME=

ENTRYPOINT ["/usr/local/bin/horizon"]
CMD ["serve"]

COPY ./volumes/go-git/horizon /usr/local/bin/