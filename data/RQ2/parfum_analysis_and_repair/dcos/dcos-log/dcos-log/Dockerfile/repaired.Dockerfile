FROM golang:1.7

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN apt-get update && apt-get install --no-install-recommends -y \
    libsystemd-dev \
    init && rm -rf /var/lib/apt/lists/*;

RUN go get -u golang.org/x/lint/golint

