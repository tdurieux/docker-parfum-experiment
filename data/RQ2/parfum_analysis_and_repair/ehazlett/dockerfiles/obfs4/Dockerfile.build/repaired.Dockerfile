FROM golang:1.6-alpine
RUN apk add --no-cache -U git
RUN go get git.torproject.org/pluggable-transports/obfs4.git/obfs4proxy
