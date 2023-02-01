FROM golang:1.10.8

RUN apt-get update -yy && \
  apt-get install --no-install-recommends -yy git make curl libxml2-dev libxmlsec1-dev liblzma-dev pkg-config xmlsec1 postgresql-client && rm -rf /var/lib/apt/lists/*;

WORKDIR /go/src/github.com/remind101/empire

ENTRYPOINT ["make"]
CMD ["test"]
