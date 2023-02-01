# Build the controller binary
FROM eu.gcr.io/kyma-project/external/golang:1.18.3-alpine3.16 as builder
ARG DOCK_PKG_DIR=/go/src/github.com/kyma-project/kyma/components/eventing-controller
WORKDIR $DOCK_PKG_DIR

COPY go.mod go.mod
COPY go.sum go.sum

COPY api/ api/
COPY cmd/ cmd/
COPY logger/ logger/
COPY options/ options/
COPY pkg/ pkg/
COPY controllers/ controllers/
COPY testing/ testing/
COPY utils/ utils/

# Build