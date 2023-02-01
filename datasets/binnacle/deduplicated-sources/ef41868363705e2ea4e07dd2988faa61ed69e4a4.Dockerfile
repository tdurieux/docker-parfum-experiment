FROM celrenheit/golang-rocksdb:1.9.1
LABEL Salim Alami <celrenheit+github@gmail.com>

EXPOSE 8080

RUN wget https://github.com/goreleaser/goreleaser/releases/download/v0.35.5/goreleaser_Linux_x86_64.tar.gz && \
    tar -zxvf goreleaser_Linux_x86_64.tar.gz && \
    chmod a+x goreleaser && mv goreleaser /usr/bin/goreleaser


WORKDIR $GOPATH/src/github.com/sandglass/sandglass


COPY . ./
