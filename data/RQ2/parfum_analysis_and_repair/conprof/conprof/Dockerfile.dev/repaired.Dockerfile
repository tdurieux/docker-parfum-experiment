FROM docker.io/node:16.16.0-alpine@sha256:554142f9a6367f1fbd776a1b2048fab3a2cc7aa477d7fe9c00ce0f110aa45716 AS ui-deps

WORKDIR /app

COPY ui/packages/shared ./packages/shared
COPY ui/packages/app/web/package.json ./packages/app/web/package.json
COPY ui/package.json ui/yarn.lock ./
RUN yarn workspace @parca/web install --frozen-lockfile

FROM docker.io/node:16.16.0-alpine@sha256:554142f9a6367f1fbd776a1b2048fab3a2cc7aa477d7fe9c00ce0f110aa45716 AS ui-builder

WORKDIR /app

COPY ui .
COPY --from=ui-deps /app/node_modules ./node_modules
RUN yarn workspace @parca/web build && yarn cache clean;

FROM docker.io/golang:1.18.4-alpine@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df AS builder

# renovate: datasource=go depName=github.com/go-delve/delve
ARG DLV_VERSION=v1.8.3

# renovate: datasource=go depName=github.com/grpc-ecosystem/grpc-health-probe
ARG GRPC_HEALTH_PROBE_VERSION=v0.4.11

WORKDIR /app

# hadolint ignore=DL3018
RUN apk update && apk add --no-cache build-base
RUN go install "github.com/go-delve/delve/cmd/dlv@${DLV_VERSION}"
# hadolint ignore=DL3059
RUN go install "github.com/grpc-ecosystem/grpc-health-probe@${GRPC_HEALTH_PROBE_VERSION}"

COPY go.mod go.sum /app/
RUN go mod download -modcacherw

COPY ./ui/ui.go ./ui/ui.go
COPY --from=ui-builder /app/packages/app/web/build ./ui/packages/app/web/build

COPY ./cmd /app/cmd
COPY ./pkg /app/pkg
COPY ./proto /app/proto
COPY ./gen /app/gen

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -gcflags="all=-N -l" -o parca ./cmd/parca

FROM docker.io/golang:1.18.4-alpine@sha256:46f1fa18ca1ec228f7ea4978ad717f0a8c5e51436e7b8efaf64011f7729886df

COPY --from=builder /go/bin/dlv /
COPY --from=builder /go/bin/grpc-health-probe /
COPY --from=builder /app/parca /parca
COPY parca.yaml /parca.yaml

EXPOSE 7070

ENTRYPOINT ["/dlv", "--listen=:40000", "--headless=true", "--api-version=2", "--accept-multiclient", "exec", "--continue", "--"]
