FROM golang:1.15-buster as builder
WORKDIR /go/src/github.com/moov-io/accounts
RUN apt-get update && apt-get install -y --no-install-recommends make gcc g++ && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN go mod download
RUN make build

FROM debian:10
MAINTAINER Moov <support@moov.io>

RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /go/src/github.com/moov-io/accounts/bin/server /bin/server

# USER moov
EXPOSE 8080
EXPOSE 9090
ENTRYPOINT ["/bin/server"]
