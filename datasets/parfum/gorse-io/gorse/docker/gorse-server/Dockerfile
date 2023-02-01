############################
# STEP 1 build executable binary
############################
FROM golang:1.18

COPY . gorse

RUN cd gorse && \
    go get -v -t -d ./...

RUN cd gorse/cmd/gorse-server && \
    CGO_ENABLED=0 go build -ldflags=" \
       -X 'github.com/zhenghaoz/gorse/cmd/version.Version=$(git describe --tags $(git rev-parse HEAD))' \
       -X 'github.com/zhenghaoz/gorse/cmd/version.GitCommit=$(git rev-parse HEAD)' \
       -X 'github.com/zhenghaoz/gorse/cmd/version.BuildTime=$(date)'" . && \
    mv gorse-server /usr/bin

RUN /usr/bin/gorse-server --version

############################
# STEP 2 build a small image
############################
FROM scratch

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=0 /usr/bin/gorse-server /usr/bin/gorse-server

ENV USER root

ENTRYPOINT ["/usr/bin/gorse-server"]
