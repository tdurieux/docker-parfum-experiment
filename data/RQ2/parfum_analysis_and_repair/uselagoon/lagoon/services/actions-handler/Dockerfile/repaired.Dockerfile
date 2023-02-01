# build the binary
ARG GO_VERSION
ARG UPSTREAM_REPO
ARG UPSTREAM_TAG
FROM golang:${GO_VERSION:-1.16.4} AS builder
# bring in all the packages
COPY . /go/src/github.com/uselagoon/lagoon/services/actions-handler/
WORKDIR /go/src/github.com/uselagoon/lagoon/services/actions-handler/

# tests currently don't work because mocking rabbit is interesting
RUN GO111MODULE=on go test ./...
# compile
RUN CGO_ENABLED=0  GOOS=linux GOARCH=amd64 go build -a -o actions-handler .

# put the binary into container
# use the commons image to get entrypoints
FROM ${UPSTREAM_REPO:-uselagoon}/commons:${UPSTREAM_TAG:-latest}

ARG LAGOON_VERSION
ENV LAGOON_VERSION=$LAGOON_VERSION

WORKDIR /app/

# bring the actions-handler binary from the builder
COPY --from=builder /go/src/github.com/uselagoon/lagoon/services/actions-handler/actions-handler .

ENV LAGOON=actions-handler
# set defaults