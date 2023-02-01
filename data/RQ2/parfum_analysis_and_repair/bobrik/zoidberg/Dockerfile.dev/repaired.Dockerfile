FROM alpine:3.6

RUN apk --update --no-cache add go libc-dev ca-certificates

COPY . /go/src/github.com/bobrik/zoidberg

RUN GOPATH=/go go install -v github.com/bobrik/zoidberg/cmd/... && \

ENTRYPOINT ["/go/bin/zoidberg"]
