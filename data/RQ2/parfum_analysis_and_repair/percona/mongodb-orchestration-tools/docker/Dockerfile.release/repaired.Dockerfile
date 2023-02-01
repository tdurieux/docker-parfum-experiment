ARG GOLANG_DOCKERHUB_TAG

FROM golang:$GOLANG_DOCKERHUB_TAG

WORKDIR /go/src/github.com/percona/mongodb-orchestration-tools
COPY . .

RUN apt-get update && \
    apt-get install --no-install-recommends -y upx-ucl zip && \
    apt-get clean all && rm -rf /var/lib/apt/lists/*;

CMD make test-full && \
    make && \
    upx bin/*
