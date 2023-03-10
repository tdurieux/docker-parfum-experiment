FROM golang:alpine
ENV CGO_ENABLED=0
WORKDIR $GOPATH/src/github.com/coreos/container-linux-config-transpiler
COPY . .
RUN apk update && apk add --no-cache --virtual .build-deps bash git make \
    && make \
    && mv bin/ct /usr/bin/ \
    && mv Dockerfile.build-alpine /tmp \
    && rm -rf $GOPATH \
    && apk del .build-deps && rm -rf /var/cache/apk
WORKDIR /tmp
ENTRYPOINT ["/usr/bin/ct"]
