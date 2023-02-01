# Duplicated build process (to ../../Dockerfile), to ease iterating locally using this stack in containers
# If there was an INCLUDE instruction in Dockerfile's we could avoid some duplication here.
#
# For real world usage, use buildkite/sockguard:latest from Docker Hub
#
FROM golang:1.10-alpine as builder
RUN apk add --no-cache ca-certificates
WORKDIR /go/src/github.com/buildkite/sockguard
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
  go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/sockguard

# So we can get a shell if we need to dig around for local testing. Main Dockerfile uses scratch
FROM alpine:3.8
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/bin/sockguard /sockguard
ENTRYPOINT [ "/sockguard" ]
