ARG GO_VERSION

FROM golang:${GO_VERSION} AS builder

RUN mkdir -p /workspace/github.com/uber/makisu
WORKDIR /workspace/github.com/uber/makisu

ADD Makefile .
ADD go.mod ./go.mod
ADD go.sum ./go.sum
RUN make vendor
ADD .git ./.git
ADD bin ./bin
ADD lib ./lib
ADD mocks ./mocks
RUN make bins

FROM alpine:3.6
RUN apk add --no-cache libc6-compat

COPY --from=builder /workspace/github.com/uber/makisu/bin/makisu/makisu /makisu-internal/makisu
ADD ./assets/cacerts.pem /makisu-internal/certs/cacerts.pem

ENTRYPOINT ["/makisu-internal/makisu"]