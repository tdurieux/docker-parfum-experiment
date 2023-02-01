FROM golang:1.18-alpine as builder

RUN mkdir -p /go/src/build

WORKDIR /go/src/build

COPY app/go.mod .
COPY app/go.sum .
RUN go mod download

ADD app /go/src/build/

# RUN CGO_ENABLED=0 go build -o worker workers/worker.go
ARG SKAFFOLD_GO_GCFLAGS
RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o dataplane mainapp/server.go

FROM node:16.10.0-bullseye-slim as builder2

RUN mkdir -p /node
RUN mkdir -p /node/app/mainapp/frontbuild

WORKDIR /node

ADD frontend/public /node/public
ADD frontend/src /node/src
ADD frontend/craco.config.js /node/craco.config.js
ADD frontend/package.json /node/package.json

RUN yarn add global env-cmd && yarn cache clean;
RUN yarn builddocker && yarn cache clean;


FROM alpine:3.15

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


COPY --from=builder2 /node/app/mainapp/frontbuild /dataplane/frontbuild
# COPY --from=builder go/src/build/app/mainapp/frontbuild/ /workerdev/frontbuild/
COPY --from=builder go/src/build/dataplane /workerdev/dataplane
WORKDIR /workerdev

# COPY ../workers/go.mod /workerdev/go.mod
# RUN go mod download

# Use an unprivileged user.
ENV GOTRACEBACK=single
USER appuser:appuser

CMD ["dataplane"]