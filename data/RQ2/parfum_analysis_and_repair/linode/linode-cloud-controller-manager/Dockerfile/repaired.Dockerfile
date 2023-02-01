# NB: We now cross-compile the go binary locally using the Makefile
FROM alpine:latest
RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
COPY dist/linode-cloud-controller-manager-linux-amd64 /
ENTRYPOINT ["/linode-cloud-controller-manager-linux-amd64"]
