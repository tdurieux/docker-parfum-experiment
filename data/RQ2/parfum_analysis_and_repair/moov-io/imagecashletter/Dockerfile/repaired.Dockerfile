FROM golang:1.18 as builder
WORKDIR /go/src/github.com/moov-io/imagecashletter
RUN apt-get update && apt-get install -y --no-install-recommends make gcc g++ && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN make build-server

FROM debian:stable-slim
LABEL maintainer="Moov <support@moov.io>"
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /go/src/github.com/moov-io/imagecashletter/bin/server /bin/server
# USER moov

EXPOSE 8080
EXPOSE 9090
ENTRYPOINT ["/bin/server"]
