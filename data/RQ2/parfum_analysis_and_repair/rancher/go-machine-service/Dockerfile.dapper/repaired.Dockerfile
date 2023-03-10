FROM golang:1.6.2
RUN go get github.com/rancher/trash
RUN go get github.com/golang/lint/golint
RUN curl -f -sL https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 > /usr/bin/docker && \
    chmod +x /usr/bin/docker
RUN apt-get update && \
    apt-get install --no-install-recommends -y --force-yes xz-utils && rm -rf /var/lib/apt/lists/*;
ENV PATH /go/bin:$PATH
ENV DAPPER_SOURCE /go/src/github.com/rancher/go-machine-service
ENV DAPPER_OUTPUT bin dist
ENV DAPPER_DOCKER_SOCKET true
ENV DAPPER_ENV TAG REPO
ENV GO15VENDOREXPERIMENT 1
ENV TRASH_CACHE ${DAPPER_SOURCE}/.trash-cache
WORKDIR ${DAPPER_SOURCE}
ENTRYPOINT ["./scripts/entry"]
CMD ["ci"]
