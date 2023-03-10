FROM golang:1.16-alpine3.12 AS dapper

ARG ARCH=amd64

RUN apk -U --no-cache add bash coreutils git gcc musl-dev docker-cli vim less file curl wget ca-certificates
RUN apk -U --no-cache add py3-pip && pip install --no-cache-dir kubernetes termplotlib==v0.3.4

ENV DAPPER_RUN_ARGS --privileged -v kine-cache:/go/src/github.com/k3s-io/kine/.cache
ENV DAPPER_ENV ARCH REPO TAG DRONE_TAG IMAGE_NAME CROSS
ENV DAPPER_SOURCE /go/src/github.com/k3s-io/kine/
ENV DAPPER_DOCKER_SOCKET true
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["test"]
