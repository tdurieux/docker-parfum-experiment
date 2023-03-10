FROM golang:1.18-alpine3.15 AS prepare

RUN apk add --no-cache git openssh openssl-dev pkgconf gcc g++ make libc-dev bash

WORKDIR /root

COPY go.mod .
COPY go.sum .
RUN go mod download


FROM prepare AS build
COPY cmd cmd
COPY pkg pkg
COPY internal internal

RUN for name in assets db ender http integrations sink storage;do CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -o bin/$name -tags musl openreplay/backend/cmd/$name; done

FROM alpine AS entrypoint
#FROM pygmy/alpine-tini:latest
RUN apk add --no-cache ca-certificates

ENV TZ=UTC \
    FS_ULIMIT=1000 \
    FS_DIR=/filestorage \
    MAXMINDDB_FILE=/root/geoip.mmdb \
    UAPARSER_FILE=/root/regexes.yaml \
    HTTP_PORT=80 \
    BEACON_SIZE_LIMIT=7000000 \
    KAFKA_USE_SSL=true \
    KAFKA_MAX_POLL_INTERVAL_MS=400000 \
    REDIS_STREAMS_MAX_LEN=3000 \
    TOPIC_RAW_WEB=raw \
    TOPIC_RAW_IOS=raw-ios \
    TOPIC_CACHE=cache \
    TOPIC_ANALYTICS=analytics \
    TOPIC_TRIGGER=trigger \
    GROUP_SINK=sink \
    GROUP_STORAGE=storage \
    GROUP_DB=db \
    GROUP_ENDER=ender \
    GROUP_CACHE=cache \
    AWS_REGION_WEB=eu-central-1 \
    AWS_REGION_IOS=eu-west-1 \
    AWS_REGION_ASSETS=eu-central-1 \
    CACHE_ASSETS=true \
    ASSETS_SIZE_LIMIT=6291456 \
    FS_CLEAN_HRS=12 \
    FILE_SPLIT_SIZE=300000 \
    LOG_QUEUE_STATS_INTERVAL_SEC=60

RUN mkdir $FS_DIR
#VOLUME [ $FS_DIR ] # Uncomment in case of using Bind mount.

RUN wget https://raw.githubusercontent.com/ua-parser/uap-core/master/regexes.yaml -O "$UAPARSER_FILE" &&\
  wget https://static.openreplay.com/geoip/GeoLite2-Country.mmdb -O "$MAXMINDDB_FILE"


WORKDIR /work

COPY --from=build /root/bin ./bin
COPY entrypoint.sh .

####
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["./entrypoint.sh"]