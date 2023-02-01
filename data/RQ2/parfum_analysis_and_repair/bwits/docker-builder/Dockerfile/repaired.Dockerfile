FROM alpine:3.2

RUN apk --update --no-cache add go git

ENV GOPATH /go
ENV PATH /go/bin:$PATH

