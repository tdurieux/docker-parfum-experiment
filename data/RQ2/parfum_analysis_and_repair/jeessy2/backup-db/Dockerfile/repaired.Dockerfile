# build stage
FROM golang:1.17 AS builder

WORKDIR /app
COPY . .
RUN go env -w GO111MODULE=on \
    && go env -w GOPROXY=https://goproxy.cn,direct \
    && make clean build

# final stage
FROM debian:stable-slim

LABEL name=backup-db
LABEL url=https://github.com/jeessy2/backup-db

VOLUME /app/backup-db-files

WORKDIR /app
RUN apt-get -y update \
    && apt-get install --no-install-recommends -y ca-certificates curl \
    && apt-get install --no-install-recommends -y postgresql-client \
    && apt-get install --no-install-recommends -y default-mysql-client && rm -rf /var/lib/apt/lists/*;

ENV TZ=Asia/Shanghai
COPY --from=builder /app/backup-db /app/backup-db
EXPOSE 9977
ENTRYPOINT ["/app/backup-db"]
