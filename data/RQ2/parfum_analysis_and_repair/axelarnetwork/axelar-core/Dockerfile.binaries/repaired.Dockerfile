FROM golang:1.18

RUN apt update && apt install -y --no-install-recommends \
  ca-certificates \
  git \
  make && rm -rf /var/lib/apt/lists/*;

WORKDIR $GOPATH/src/github.com/axelarnetwork/axelar-core
ARG SEMVER

COPY ./go.mod .
COPY ./go.sum .
RUN go mod download

COPY . .
ENV CGO_ENABLED=0
RUN make build-binaries
