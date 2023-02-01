# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM golang:1.18-alpine AS golatest

FROM golatest AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN --mount=target=/go/pkg,type=cache go mod download
ENV CGO_ENABLED=0
RUN --mount=target=. \
    --mount=type=cache,target=/root/.cache/go-build \
    --mount=target=/go/pkg,type=cache \
    go build -trimpath -ldflags "-s -w" -o /out/buildkit-gosh .

FROM scratch
COPY --from=build /out/ /
LABEL moby.buildkit.frontend.network.none="false"
LABEL moby.buildkit.frontend.network.host="true"
ENTRYPOINT ["/buildkit-gosh", "frontend"]