FROM golang:1.13
ARG LDFLAGS
ENV CGO_ENABLED=0
WORKDIR /go/src/github.com/cnabio/duffle
COPY cmd/ cmd/
COPY pkg/ pkg/
COPY go.mod .
COPY go.sum .
RUN GO111MODULE=on go build -ldflags "$LDFLAGS" -o bin/duffle ./cmd/...

FROM alpine:3.8
RUN apk add --no-cache bash make jq ca-certificates && update-ca-certificates
COPY --from=0 /go/src/github.com/cnabio/duffle/bin/duffle /usr/bin/duffle
CMD /usr/bin/duffle
