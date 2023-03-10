# syntax=docker/dockerfile:1.2
ARG GO_VERSION=1.16

# diun.watch_repo=true
# diun.max_tags=100
FROM --platform=$BUILDPLATFORM crazymax/goreleaser-xx:latest AS goreleaser-xx
# diun:"watch_repo=true,max_tags=100"
FROM --platform=$BUILDPLATFORM golang:${GO_VERSION}-alpine AS base
COPY --from=goreleaser-xx / /
COPY --from=crazymax/goreleaser-xx:1.2.2 / /
RUN apk add --no-cache ca-certificates gcc file git linux-headers musl-dev tar
WORKDIR /src

FROM base AS vendored
RUN --mount=type=bind,source=.,target=/src,rw \
  --mount=type=cache,target=/go/pkg/mod \
  go mod tidy && go mod download

FROM vendored AS build
ARG TARGETPLATFORM
ARG GIT_REF
RUN --mount=type=bind,target=/src,rw \
  --mount=type=cache,target=/root/.cache/go-build \
  --mount=target=/go/pkg/mod,type=cache \
  goreleaser-xx --debug \
    --name "diun" \
    --dist "/out" \
    --main="./cmd" \
    --ldflags="-s -w -X 'main.version={{.Version}}'" \
    --files="CHANGELOG.md" \
    --files="LICENSE" \
    --files="README.md"

FROM scratch AS artifact
COPY --from=build /out/*.tar.gz /
COPY --from=build /out/*.zip /

FROM alpine

RUN apk --update --no-cache add \
    ca-certificates \
    libressl \
  && rm -rf /tmp/*

COPY --from=build /usr/local/bin/diun /usr/local/bin/diun

ENV DIUN_DB_PATH="/data/diun.db"

VOLUME [ "/data" ]
ENTRYPOINT [ "diun" ]