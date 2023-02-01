# syntax=docker/dockerfile:1.4

ARG GOLANG_IMAGE=golang:1.17.8-alpine@sha256:f4ece20984a30d1065b04653bf6781f51ab63421b4b8f011565de0401cfe58d7

FROM ${GOLANG_IMAGE} AS build
WORKDIR /go/src/app
ENV CGO_ENABLED=0
# RUN --mount=target=. --mount=target=/root/.cache,type=cache --mount=target=/go/pkg,type=cache \
#   go build -trimpath -ldflags "-s -w" -o /out/buildkit-gosh .
RUN --mount=target=. --mount=target=/root/.cache,type=cache --mount=target=/go/pkg,type=cache \
    go install github.com/go-delve/delve/cmd/dlv@latest
RUN --mount=target=. --mount=target=/root/.cache,type=cache --mount=target=/go/pkg,type=cache \
    go build -gcflags "all=-N -l" -o /out/buildkit-gosh .

# FROM scratch
FROM bash
COPY --from=build /go/bin/dlv /dlv
COPY --from=build /out/ /
LABEL moby.buildkit.frontend.network.none="false"
LABEL moby.buildkit.frontend.network.host="true"
# ENTRYPOINT ["/buildkit-gosh frontend"]
# ENTRYPOINT /dlv
# CMD "--listen=:2345 --log=false --api-version=2 --headless --log-dest=/l exec /buildkit-gosh -- frontend"
EXPOSE 2345
ENTRYPOINT /dlv --listen=:2345 --api-version=2 --headless --log-dest=/l exec /buildkit-gosh -- frontend