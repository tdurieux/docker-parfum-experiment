FROM golang:1.10 as builder
WORKDIR /go/src/github.com/operator-framework/operator-lifecycle-manager
RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;
COPY pkg pkg
COPY vendor vendor
COPY test/e2e test/e2e
RUN go test -c -o /bin/e2e ./test/e2e/...
CMD ["./test/e2e/e2e.sh"]
