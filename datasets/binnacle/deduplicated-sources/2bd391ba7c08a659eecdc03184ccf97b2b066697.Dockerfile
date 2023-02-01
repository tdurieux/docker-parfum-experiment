FROM vault:1.1.3 AS vault

FROM consul:1.5.1 AS consul

FROM golang:1.12.0-alpine

COPY --from=vault /bin/vault /bin/vault
COPY --from=consul /bin/consul /bin/consul

RUN apk add --no-cache make tzdata

WORKDIR /go/src/github.com/hairyhenderson/gomplate/
COPY vendor ./vendor
COPY tests/integration ./tests/integration
COPY Makefile ./Makefile
COPY bin/gomplate_linux-amd64 ./bin/gomplate

CMD ["make", "integration"]
