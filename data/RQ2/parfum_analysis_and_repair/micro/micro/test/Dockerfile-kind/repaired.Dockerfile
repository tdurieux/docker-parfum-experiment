FROM alpine:3.12.1

COPY --from=golang:1.15-alpine /usr/local/go/ /usr/local/go/
ENV PATH="/usr/local/go/bin:${PATH}"

RUN apk --no-cache add make git gcc libtool musl-dev curl bash
RUN apk add --no-cache ca-certificates && rm -rf /var/cache/apk/* /tmp/*

COPY ./micro /micro
ENTRYPOINT ["/micro"]