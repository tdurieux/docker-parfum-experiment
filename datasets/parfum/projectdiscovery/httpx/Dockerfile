FROM golang:1.18.3-alpine AS builder
RUN apk add --no-cache git
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

FROM alpine:3.16.0
RUN apk -U upgrade --no-cache \
    && apk add --no-cache bind-tools ca-certificates
COPY --from=builder /go/bin/httpx /usr/local/bin/

ENTRYPOINT ["httpx"]
