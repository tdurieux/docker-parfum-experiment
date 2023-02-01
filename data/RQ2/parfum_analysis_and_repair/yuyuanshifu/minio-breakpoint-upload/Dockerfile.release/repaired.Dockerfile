FROM golang:1.12-alpine

ENV GOPATH /go
ENV CGO_ENABLED 0
ENV GO111MODULE on
ENV GOPROXY=https://goproxy.io

WORKDIR /root/minio-breakpoint-upload

COPY ./ ./
RUN \
    go mod download && \
    go build -o /usr/bin/minio-breakpoint-upload main.go

FROM alpine:3.9
COPY --from=0 /usr/bin/minio-breakpoint-upload /usr/bin/minio-breakpoint-upload
COPY --from=0 /usr/bin/config.json /usr/bin/config.json

RUN chmod +x /usr/bin/minio-breakpoint-upload

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/usr/bin/minio-breakpoint-upload"]