FROM golang:1.13 AS race-detector
WORKDIR /go/src/github.com/docker/oscalkit
COPY . .
WORKDIR /go/src/github.com/docker/oscalkit/cli
RUN go build -race

FROM golang:1.13
ARG GOOS
ARG GOARCH
ARG VERSION
ARG BUILD
ARG DATE
ARG BINARY
WORKDIR /go/src/github.com/docker/oscalkit
COPY --from=race-detector /go/src/github.com/docker/oscalkit .
WORKDIR /go/src/github.com/docker/oscalkit/cli
RUN CGO_ENABLED=0 GOOS=${GOOS} GOARCH=${GOARCH} go build -o /${BINARY} -v -ldflags "-s -w -X github.com/docker/oscalkit/cli/version.Version=${VERSION} -X github.com/docker/oscalkit/cli/version.Build=${BUILD} -X github.com/docker/oscalkit/cli/version.Date=${DATE}"