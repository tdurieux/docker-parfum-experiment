############################
# STEP 1 build executable binary
############################
FROM golang:1.18

COPY . gorse

RUN cd gorse && \
    go get -v -t -d ./...

RUN cd gorse/cmd/gorse-in-one && \
    CGO_ENABLED=0 go build -ldflags=" \
       -X 'github.com/zhenghaoz/gorse/cmd/version.Version=$(git describe --tags $(git rev-parse HEAD))' \
       -X 'github.com/zhenghaoz/gorse/cmd/version.GitCommit=$(git rev-parse HEAD)' \
       -X 'github.com/zhenghaoz/gorse/cmd/version.BuildTime=$(date)'" . && \
    mv gorse-in-one /usr/bin

RUN /usr/bin/gorse-in-one --version

############################
# STEP 2 build a small image
############################