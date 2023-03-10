FROM --platform=${TARGETPLATFORM:-linux/amd64} ghcr.io/openfaas/of-watchdog:0.8.4 as watchdog
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.15-alpine3.13 as build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG MICRONAME

RUN apk --no-cache add git

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

ENV CGO_ENABLED=0

RUN mkdir -p /go/src/handler
RUN mkdir -p /go/src/function
WORKDIR /go/src/handler
COPY docker/main/go.mod go.mod
COPY docker/main/main.go main.go
COPY docker/main/GO_REPLACE.txt GO_REPLACE.txt
COPY *docker/telar-core function/telar-core
RUN  sed -i "s|__micro_name|$MICRONAME|g" main.go
RUN  sed -i "s|__micro_name|$MICRONAME|g" GO_REPLACE.txt

RUN go mod tidy

COPY micros/$MICRONAME function
COPY docker/micro/GO_REPLACE.txt function/GO_REPLACE.txt
COPY docker/micro/go.mod function/go.mod
RUN  sed -i "s|__micro_name|$MICRONAME|g" function/go.mod
RUN  sed -i "s|__micro_name|$MICRONAME|g" function/GO_REPLACE.txt

# Add user overrides to the root go.mod, which is the only place "replace" can be used
RUN cat function/GO_REPLACE.txt >> ./go.mod || exit 0
RUN cat ./GO_REPLACE.txt >> function/go.mod || exit 0

# Run a gofmt and exclude all vendored code.
RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*" -not -path "./function/vendor/*"))" || { echo "Run \"gofmt -s -w\" on your Golang code"; exit 1; }

ARG GO111MODULE="on"
ARG GOPROXY=""
ARG GOFLAGS=""

WORKDIR /go/src/handler/function

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} go test ./... -cover

WORKDIR /go/src/handler
RUN CGO_ENABLED=${CGO_ENABLED} GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
    go build --ldflags "-s -w" -a -installsuffix cgo -o handler .

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:3.13
# Add non root user and certs
RUN apk --no-cache add ca-certificates \
    && addgroup -S app && adduser -S -g app app
# Split instructions so that buildkit can run & cache 
# the previous command ahead of time.
RUN mkdir -p /home/app \
    && chown app /home/app

WORKDIR /home/app

COPY --from=build --chown=app /go/src/handler/handler    .
COPY --from=build --chown=app /usr/bin/fwatchdog         .
COPY --from=build --chown=app /go/src/handler/function/  .

USER app

ENV fprocess="./handler"
ENV mode="http"
ENV upstream_url="http://127.0.0.1:8082"
ENV prefix_logs="false"

CMD ["./fwatchdog"]