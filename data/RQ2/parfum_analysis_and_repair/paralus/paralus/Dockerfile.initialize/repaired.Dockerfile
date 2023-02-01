FROM golang:1.17 as build
LABEL description="Build container"

ENV CGO_ENABLED 0
COPY . /build
WORKDIR /build
RUN go build -ldflags "-s" -o paralus-init scripts/initialize/main.go
RUN wget -O kratos.tar.gz -q https://github.com/ory/kratos/releases/download/v0.8.0-alpha.3/kratos_0.8.0-alpha.3_linux_64bit.tar.gz && tar -xf kratos.tar.gz && rm kratos.tar.gz
RUN wget -O migrate.tar.gz -q https://github.com/golang-migrate/migrate/releases/download/v4.15.2/migrate.linux-amd64.tar.gz && tar -xf migrate.tar.gz && rm migrate.tar.gz

FROM alpine:latest as runtime
LABEL description="Run container"

WORKDIR /usr/bin
COPY --from=build /build/paralus-init /usr/bin/paralus-init
COPY --from=build /build/scripts/initialize/ /usr/bin/scripts/initialize/

COPY --from=build /build/kratos /usr/bin/kratos

COPY --from=build /build/migrate /usr/bin/migrate
COPY ./persistence/migrations/admindb /data/migrations/admindb
