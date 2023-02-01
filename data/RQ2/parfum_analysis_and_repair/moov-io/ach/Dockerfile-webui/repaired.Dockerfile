FROM golang:1.18 as builder
WORKDIR /go/src/github.com/moov-io/ach
RUN apt-get update && apt-get install -y --no-install-recommends make gcc g++ && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN make build-webui

FROM debian:stable-slim
LABEL maintainer="Moov <support@moov.io>"
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /go/src/github.com/moov-io/ach/bin/webui /bin/webui
COPY --from=builder /go/src/github.com/moov-io/ach/cmd/webui/assets/ /assets/
# USER moov

ENV ASSETS_PATH=../assets/

EXPOSE 8083
EXPOSE 9093
ENTRYPOINT ["/bin/webui"]
