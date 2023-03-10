FROM golang:alpine AS builder

ENV GO111MODULE=auto

RUN buildDeps=' \
                make \
                git \
        ' \
        set -x \
        && apk --no-cache add $buildDeps \
        && mkdir -p /go/src/github.com/jrasell/chemtrail

WORKDIR /go/src/github.com/jrasell/chemtrail

COPY . /go/src/github.com/jrasell/chemtrail

RUN \
        make tools && \
        make build

FROM alpine:latest AS app

LABEL maintainer James Rasell<(jamesrasell@gmail.com)> (@jrasell)
LABEL vendor "jrasell"

WORKDIR /usr/bin/

COPY --from=builder /go/src/github.com/jrasell/chemtrail/chemtrail /usr/bin/chemtrail

RUN \
        apk --no-cache add \
        ca-certificates \
        && chmod +x /usr/bin/chemtrail \
        && echo "Build complete."

ENTRYPOINT ["chemtrail"]

CMD ["--help"]