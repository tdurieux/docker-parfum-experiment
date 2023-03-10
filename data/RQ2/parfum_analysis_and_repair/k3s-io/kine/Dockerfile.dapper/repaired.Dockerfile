FROM golang:1.16-alpine3.12 AS dapper

ARG ARCH=amd64

RUN apk -U --no-cache add bash coreutils git gcc musl-dev docker-cli vim less file curl wget ca-certificates
RUN GO111MODULE=on GOPROXY=direct go get golang.org/x/lint/golint@83fdc39ff7b56453e3793356bcff3070b9b96445
RUN GO111MODULE=on GOPROXY=direct go get golang.org/x/tools/cmd/goimports@gopls/v0.6.9
RUN rm -rf /go/src /go/pkg

RUN if [ "${ARCH}" == "amd64" ]; then \
        curl -f -sL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.38.0; \
    fi

ENV DAPPER_RUN_ARGS --privileged -v kine-cache:/go/src/github.com/k3s-io/kine/.cache
ENV DAPPER_ENV ARCH REPO TAG DRONE_TAG IMAGE_NAME CROSS SKIP_VALIDATE
ENV DAPPER_SOURCE /go/src/github.com/k3s-io/kine/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
