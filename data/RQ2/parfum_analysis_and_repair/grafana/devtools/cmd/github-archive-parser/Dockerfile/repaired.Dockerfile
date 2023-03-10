# Builder image
FROM golang:1.13 AS builder

WORKDIR /build/

COPY ./cmd ./cmd
COPY ./pkg ./pkg
COPY ./vendor ./vendor
COPY ./go.mod ./go.sum ./

RUN go build -mod=vendor \
  -o /build/github-archive-parser \
  ./cmd/github-archive-parser

# Runtime image

FROM debian:buster-slim AS runtime

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /build/github-archive-parser /bin/github-archive-parser

ENTRYPOINT [ "/bin/github-archive-parser" ]
CMD [ "-help" ]
