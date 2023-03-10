# Build
FROM golang:1.18.3-alpine AS build-env
RUN apk add --no-cache build-base
RUN go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest

# Release
FROM alpine:3.16.0
RUN apk -U upgrade --no-cache \
    && apk add --no-cache bind-tools ca-certificates
COPY --from=build-env /go/bin/interactsh-client /usr/local/bin/interactsh-client

ENTRYPOINT ["interactsh-client"]