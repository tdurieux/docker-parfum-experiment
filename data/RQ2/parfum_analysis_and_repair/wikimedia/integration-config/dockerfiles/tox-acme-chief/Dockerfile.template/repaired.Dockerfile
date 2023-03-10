FROM {{ "ci-buster" | image_tag }} as pebble-builder

USER root

RUN {{ "golang-go" | apt_install }}
WORKDIR /root
RUN go mod init . && \
    go get -d github.com/letsencrypt/pebble@v1.0.1 && \
    CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static" -w -s' ./go/pkg/mod/github.com/letsencrypt/pebble\@v1.0.1/cmd/pebble/

USER nobody

FROM {{ "tox" | image_tag }}

USER root
COPY --from=pebble-builder /root/pebble /usr/local/bin/pebble

USER nobody