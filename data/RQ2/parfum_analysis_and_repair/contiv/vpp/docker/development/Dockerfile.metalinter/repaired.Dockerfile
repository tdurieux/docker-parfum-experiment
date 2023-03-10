FROM golang:1.13.8-alpine3.10

# gometalinter.v2 --install requires git to be installed
RUN apk add --no-cache git

RUN go get -u gopkg.in/alecthomas/gometalinter.v2
RUN gometalinter.v2 --install

COPY . /go/src/github.com/contiv/vpp

WORKDIR /go/src/github.com/contiv/vpp

# --vendor doesn't 100% properly exclude the vendor dir, so manually exclude it
ENTRYPOINT ["gometalinter.v2", "--vendor", "--exclude", "vendor", "./..."]