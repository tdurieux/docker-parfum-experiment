FROM golang:1.6.2

RUN apt-get update && apt-get install --no-install-recommends -y fuse && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/src/github.com/chenchun/cgroupfs
COPY . /go/src/github.com/chenchun/cgroupfs
RUN go build -o /tmp/cgroupfs cli/cli.go

