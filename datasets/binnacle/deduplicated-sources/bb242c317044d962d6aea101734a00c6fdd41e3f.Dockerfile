FROM --platform=$BUILDPLATFORM golang:1.10.4-alpine as builder
RUN mkdir -p /go/src/github.com/zeerorg/cron-connector
WORKDIR /go/src/github.com/zeerorg/cron-connector

COPY vendor       vendor
COPY types        types
COPY main_test.go .
COPY main.go      .

# Run a gofmt and exclude all vendored code.
RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*"))"

RUN go test -v ./...

ARG TARGETARCH
ENV GOARCH=$TARGETARCH

# Stripping via -ldflags "-s -w" 
RUN CGO_ENABLED=0 GOOS=linux GOARCH=$GOARCH go build -a -ldflags "-s -w" -installsuffix cgo -o ./connector

FROM alpine:3.8

RUN addgroup -S app \
    && adduser -S -g app app

WORKDIR /home/app

COPY --from=builder /go/src/github.com/zeerorg/cron-connector/connector    .

RUN chown -R app:app ./

USER app

CMD ["./connector"]