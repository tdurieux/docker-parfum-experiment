FROM golang:1.17-alpine as builder

RUN mkdir -p /go/src/build

WORKDIR /go/src/build

COPY workers/go.mod .
COPY workers/go.sum .
RUN go mod download

ADD workers /go/src/build/

RUN CGO_ENABLED=0 go build -o main worker.go


FROM python:alpine3.15

RUN apk update && apk add --no-cache git ca-certificates tzdata && update-ca-certificates

# Create appuser
ENV USER=appuser
ENV UID=10001
ARG GITHUB_USER
ARG GITHUB_TOKEN

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/workerdev" \
    --shell "/sbin/nologin" \
#    --no-create-home \
    --uid "${UID}" \
    "${USER}"


COPY --from=builder go/src/build/main /workerdev/main
WORKDIR /workerdev

COPY ./workers/go.mod /workerdev/go.mod
RUN go mod download

# Use an unprivileged user.
USER appuser:appuser

CMD ["main"]