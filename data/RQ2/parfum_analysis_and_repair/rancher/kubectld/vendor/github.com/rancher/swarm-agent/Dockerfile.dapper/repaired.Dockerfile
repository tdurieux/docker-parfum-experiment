FROM golang:1.5
RUN go get github.com/imikushin/trash
RUN go get github.com/golang/lint/golint
RUN curl -f -sL https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 > /usr/bin/docker && \
    chmod +x /usr/bin/docker
ENV PATH /go/bin:$PATH
ENV DAPPER_SOURCE /go/src/github.com/rancher/swarm-agent
ENV DAPPER_OUTPUT bin
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_ENV TAG REPO
ENV GO15VENDOREXPERIMENT 1
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
WORKDIR ${DAPPER_SOURCE}
ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
