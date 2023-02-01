# builder image
FROM golang:1.12-alpine3.9 as builder

ENV CGO_ENABLED 0
ENV GO111MODULE on
RUN apk --no-cache add git
WORKDIR /go/src/github.com/linki/chaoskube
COPY . .
RUN go test -v ./...
ENV GOARCH ppc64le
RUN go build -o /bin/chaoskube -v \
  -ldflags "-X main.version=$(git describe --tags --always --dirty) -w -s"

# final image
FROM ppc64le/alpine:3.9
MAINTAINER Linki <linki+docker.com@posteo.de>

COPY --from=builder /bin/chaoskube /bin/chaoskube

USER 65534
ENTRYPOINT ["/bin/chaoskube"]
