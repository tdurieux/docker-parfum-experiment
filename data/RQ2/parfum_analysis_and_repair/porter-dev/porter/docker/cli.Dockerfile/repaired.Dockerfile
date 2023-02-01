# Base Go environment
# -------------------
FROM golang:1.18 as base
WORKDIR /porter

RUN apt-get update && apt-get install --no-install-recommends -y gcc musl-dev git make && rm -rf /var/lib/apt/lists/*;

COPY go.mod go.sum ./
COPY Makefile .
COPY /cli ./cli
COPY /internal ./internal
COPY /api ./api
COPY /pkg ./pkg

RUN --mount=type=cache,target=$GOPATH/pkg/mod \
    go mod download

# Go build environment
# --------------------
FROM base AS build-go

ARG version=production

RUN make build-cli

# Deployment environment
# ----------------------
FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=build-go /porter/bin/porter .

RUN chmod +x ./porter && mv ./porter /usr/local/bin/

ENTRYPOINT ["porter"]
