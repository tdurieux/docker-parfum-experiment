FROM golang:1.17.3-alpine3.14@sha256:55da409cc0fe11df63a7d6962fbefd1321fedc305d9969da636876893e289e2d

# hadolint ignore=DL3018
RUN apk --no-cache add \
    build-base \
    docker \
    openrc \
    bash \
    && rc-update add docker boot

WORKDIR /app

COPY . .

WORKDIR /app/test/infra