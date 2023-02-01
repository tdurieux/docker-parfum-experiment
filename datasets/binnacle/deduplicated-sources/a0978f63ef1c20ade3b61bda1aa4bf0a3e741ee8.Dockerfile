FROM golang:1.11.5-alpine3.8 as builder
WORKDIR /go/src/github.com/sapcc/kubernikus/
RUN apk add --no-cache make git curl
RUN curl -Lf https://github.com/alecthomas/gometalinter/releases/download/v2.0.11/gometalinter-2.0.11-linux-amd64.tar.gz \
		| tar --strip-components=1 -C /usr/local/bin -zxv \
		&& gometalinter --version
COPY . .
ARG VERSION
#We run gofmt and linter before compiling for faster feedback
RUN make gofmt linters
RUN make all
RUN make gotest
RUN make build-e2e

FROM scratch as kubernikus-binaries
COPY --from=builder /go/src/github.com/sapcc/kubernikus/bin/linux/* /
