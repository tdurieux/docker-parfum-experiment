FROM golang:latest

ADD server /bin

ENTRYPOINT ["/bin/server"]