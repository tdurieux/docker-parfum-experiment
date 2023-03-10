# Build the webhook binary
FROM golang:1.14.2 as builder

WORKDIR /go/src/github.com/Alluxio/alluxio
COPY . .

# Build
# RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -o webhook main.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=off go build -a -o /go/bin/alluxio-webhook cmd/webhook/*.go


# Use distroless as minimal base image to package the webhook binary
# Refer to https://github.com/GoogleContainerTools/distroless for more details
FROM alpine:3.10
RUN apk add --no-cache --update curl tzdata iproute2 bash libc6-compat vim && \
  rm -rf /var/cache/apk/* && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" >  /etc/timezone

WORKDIR /
COPY --from=builder /go/bin/alluxio-webhook /usr/bin/alluxio-webhook
RUN chmod u+x /usr/bin/alluxio-webhook

ENTRYPOINT ["alluxio-webhook"]
