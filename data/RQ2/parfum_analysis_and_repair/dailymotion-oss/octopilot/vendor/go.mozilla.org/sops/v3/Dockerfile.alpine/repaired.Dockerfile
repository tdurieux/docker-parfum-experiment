FROM golang:1.12-alpine3.10 AS builder

RUN apk --no-cache add make

COPY . /go/src/go.mozilla.org/sops
WORKDIR /go/src/go.mozilla.org/sops

RUN CGO_ENABLED=1 make install


FROM alpine:3.10

RUN apk --no-cache add \
  vim ca-certificates
ENV EDITOR vim
COPY --from=builder /go/bin/sops /usr/local/bin/sops
ENTRYPOINT ["/usr/local/bin/sops"]