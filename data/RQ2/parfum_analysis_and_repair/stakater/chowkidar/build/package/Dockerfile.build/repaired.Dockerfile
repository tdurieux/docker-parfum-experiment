FROM stakater/go-glide:1.9.3
MAINTAINER "Stakater Team"

RUN apk update

RUN apk -v --no-cache --update \
    add git build-base && \
    rm -rf /var/cache/apk/* && \
    mkdir -p "$GOPATH/src/github.com/stakater/Chowkidar"

ADD . "$GOPATH/src/github.com/stakater/Chowkidar"

RUN cd "$GOPATH/src/github.com/stakater/Chowkidar" && \
    glide update && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a --installsuffix cgo --ldflags="-s" -o /Chowkidar

COPY build/package/Dockerfile.run /

# Running this image produces a tarball suitable to be piped into another
# Docker build command.
CMD tar -cf - -C / Dockerfile.run Chowkidar
