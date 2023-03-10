FROM golang:1.10.8

LABEL version 0.13.0

RUN apt-get update -yy && \
  apt-get install --no-install-recommends -yy git make curl libxml2-dev libxmlsec1-dev liblzma-dev pkg-config xmlsec1 && rm -rf /var/lib/apt/lists/*;

ADD . /go/src/github.com/remind101/empire
WORKDIR /go/src/github.com/remind101/empire
RUN go install ./cmd/empire
RUN ldd /go/bin/empire || true

ENTRYPOINT ["/go/bin/empire"]
CMD ["server"]

EXPOSE 8080
