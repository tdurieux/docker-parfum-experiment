ARG GO_VERSION=1.14.2
ARG ALPINE_VERSION=3.11
ARG gomodguard_VERSION=

# ---- App container
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}
WORKDIR /
RUN apk --no-cache add ca-certificates
COPY gomodguard /gomodguard
ENTRYPOINT ./gomodguard