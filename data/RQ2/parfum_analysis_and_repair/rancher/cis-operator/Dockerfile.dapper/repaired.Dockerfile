FROM golang:1.15.7-alpine3.12

ARG DAPPER_HOST_ARCH
ENV ARCH $DAPPER_HOST_ARCH

RUN apk -U --no-cache add bash git gcc musl-dev docker vim less file curl wget ca-certificates
RUN go get -d golang.org/x/lint/golint && \
    git -C /go/src/golang.org/x/lint/golint checkout -b current 06c8688daad7faa9da5a0c2f163a3d14aac986ca && \
    go install golang.org/x/lint/golint && \
    rm -rf /go/src /go/pkg
RUN mkdir -p /go/src/golang.org/x && \
    cd /go/src/golang.org/x && git clone https://github.com/golang/tools && \
    git -C /go/src/golang.org/x/tools checkout -b current aa82965741a9fecd12b026fbb3d3c6ed3231b8f8 && \
    go install golang.org/x/tools/cmd/goimports
RUN rm -rf /go/src /go/pkg
RUN if [ "${ARCH}" == "amd64" ]; then \
        curl -f -sL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.27.0; \
    fi

ENV DAPPER_ENV REPO TAG DRONE_TAG CROSS
ENV DAPPER_SOURCE /go/src/github.com/rancher/cis-operator/
ENV DAPPER_OUTPUT ./bin ./dist
ENV DAPPER_DOCKER_SOCKET true
ENV HOME ${DAPPER_SOURCE}
WORKDIR ${DAPPER_SOURCE}

ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
