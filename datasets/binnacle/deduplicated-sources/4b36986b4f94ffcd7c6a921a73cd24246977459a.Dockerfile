FROM alpine
MAINTAINER Samuel Huang "samuelh2006@gmail.com"

RUN apk add git build-base go
RUN GOPATH=/go go get github.com/txthinking/brook/cli/brook

USER nobody

ENTRYPOINT ["/go/bin/brook"]
