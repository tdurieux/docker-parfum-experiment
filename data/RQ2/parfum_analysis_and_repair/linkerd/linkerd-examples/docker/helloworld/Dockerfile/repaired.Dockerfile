##### build stage ###########################################################
ARG BUILDPLATFORM=linux/amd64

FROM --platform=$BUILDPLATFORM golang:1.9.2-alpine as golang

ADD . /go/src/github.com/linkerd/linkerd-examples/docker/helloworld/
ARG TARGETARCH
RUN GOOS=linux GOARCH=$TARGETARCH go build -o /go/bin/helloworld /go/src/github.com/linkerd/linkerd-examples/docker/helloworld/main.go
RUN GOOS=linux GOARCH=$TARGETARCH go build -o /go/bin/helloworld-client /go/src/github.com/linkerd/linkerd-examples/docker/helloworld/helloworld-client/main.go

##### run stage #############################################################
FROM alpine:3.6

RUN apk add --no-cache --update curl jq && rm -rf /var/cache/apk/*

COPY ./hostIP.sh /usr/local/bin

COPY --from=golang /go/bin/helloworld        /usr/local/bin/helloworld
COPY --from=golang /go/bin/helloworld-client /usr/local/bin/helloworld-client

ENTRYPOINT ["/usr/local/bin/helloworld"]
