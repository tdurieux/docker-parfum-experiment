FROM golang:1.8.1-alpine

RUN apk add --update tini curl \
  && rm -r /var/cache
ENTRYPOINT ["/sbin/tini", "--"]

RUN mkdir -p /go/src/app
WORKDIR /go/src/app

COPY . /go/src/app
RUN go-wrapper download
RUN go-wrapper install

HEALTHCHECK --interval=5s --timeout=3s \
  CMD curl --fail http://localhost:$PORT/_health || exit 1

# Run under Tini
CMD ["go-wrapper", "run", "main.go"]
