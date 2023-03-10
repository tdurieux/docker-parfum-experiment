FROM golang:1.14-alpine AS builder

RUN apk -U --no-cache add build-base

WORKDIR /go/src/github.com/ory/x

ADD go.mod go.mod
ADD go.sum go.sum

RUN go mod download

ADD . .

RUN go build -o /usr/bin/eventlogger ./watcherx/integrationtest

FROM alpine:3.11

COPY --from=builder /usr/bin/eventlogger /usr/bin/eventlogger

ENTRYPOINT ["eventlogger"]
CMD ["/etc/config/mock-config"]