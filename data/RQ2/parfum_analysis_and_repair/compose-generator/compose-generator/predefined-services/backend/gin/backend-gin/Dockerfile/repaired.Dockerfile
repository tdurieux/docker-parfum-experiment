# Builder
FROM golang:${{GIN_GO_VERSION}}-alpine AS builder
ENV USER=appuser
ENV UID=10001
ENV GO111MODULE=on

RUN adduser --disabled-password --gecos "" --home "/nonexistent" --shell "/sbin/nologin" --no-create-home --uid "${UID}" "${USER}"
RUN apk update && apk add --no-cache ca-certificates tzdata && update-ca-certificates
WORKDIR /app

COPY . .

RUN go mod download
RUN go mod verify

RUN CGO_ENABLED=0 go build -ldflags='-w -s -extldflags "-static"' -a -o /go/bin/${{GIN_APP_NAME}}
RUN chmod +x /go/bin/${{GIN_APP_NAME}}


# Minimalistic image