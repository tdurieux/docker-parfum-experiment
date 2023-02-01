FROM golang:1.14-alpine3.11 AS builder

ARG GO_LDFLAGS

# install build tools
RUN apk update
RUN apk add --no-cache build-base bash

WORKDIR /code
# copy source
COPY . .
RUN make build WHAT=gm GO_LDFLAGS=$GO_LDFLAGS OUT_DIR=_output

# ALT: just using go build
# RUN CGO_ENABLED=0 go build -o _output/bin/neptune-gm -ldflags "$GO_LDFLAGS -w -s" cmd/neptune-gm/neptune-gm.go

FROM alpine:3.11

COPY --from=builder /code/_output/bin/neptune-gm /usr/local/bin/neptune-gm

COPY build/gm/gm-config.yaml /gm.yaml

CMD ["neptune-gm", "--config", "/gm.yaml"]
