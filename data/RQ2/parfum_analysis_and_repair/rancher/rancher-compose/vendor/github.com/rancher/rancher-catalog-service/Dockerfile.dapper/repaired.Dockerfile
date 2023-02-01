FROM golang:1.5
RUN go get github.com/tools/godep
RUN go get github.com/golang/lint/golint
ENV DAPPER_SOURCE /go/src/github.com/rancher/rancher-catalog-service
ENV DAPPER_OUTPUT bin dist
RUN apt-get update && apt-get install --no-install-recommends -y xz-utils && rm -rf /var/lib/apt/lists/*;
WORKDIR ${DAPPER_SOURCE}
ENTRYPOINT ["./scripts/entry"]
CMD ["build"]
