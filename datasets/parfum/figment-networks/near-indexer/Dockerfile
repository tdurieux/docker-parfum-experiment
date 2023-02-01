# ------------------------------------------------------------------------------
# Builder Image
# ------------------------------------------------------------------------------
FROM golang AS build

WORKDIR /go/src/github.com/figment-networks/near-indexer

COPY ./go.mod .
COPY ./go.sum .

RUN go mod download

COPY . .

ENV CGO_ENABLED=0
ENV GOARCH=amd64
ENV GOOS=linux

# Without updating PATH with $GOPATH/bin/linux_amd64 it fails when you try to build Dokcker on Apple M1
ENV PATH $PATH:$GOPATH/bin/linux_amd64
RUN make setup

RUN \
  GO_VERSION=$(go version | awk {'print $3'}) \
  GIT_COMMIT=$(git rev-parse HEAD) \
  make build

# ------------------------------------------------------------------------------
# Target Image
# ------------------------------------------------------------------------------
FROM alpine AS release

WORKDIR /app

RUN addgroup --gid 1234 figment
RUN adduser --system --uid 1234 figment

COPY --from=build \
  /go/src/github.com/figment-networks/near-indexer/near-indexer \
  /app/near-indexer

EXPOSE 8081

USER 1234

ENTRYPOINT ["/app/near-indexer"]
