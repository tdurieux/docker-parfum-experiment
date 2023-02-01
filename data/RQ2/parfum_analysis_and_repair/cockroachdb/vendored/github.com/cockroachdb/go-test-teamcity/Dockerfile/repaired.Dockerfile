FROM alpine:3.3

RUN apk --update --no-cache add ca-certificates

ADD . /go/src/github.com/2tvenom/go-test-teamcity

ENV GOPATH=/go
RUN apk add --no-cache go && \
    go install github.com/2tvenom/go-test-teamcity && \
    apk del go && \
    cp /go/bin/go-test-teamcity /converter && \
    rm -rf /go /usr/local/go

ENTRYPOINT ["/converter"]
