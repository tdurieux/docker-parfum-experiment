FROM golang:1.11

RUN mkdir -p /go/src/github.com/openfaas-incubator/openfaas-operator/

WORKDIR /go/src/github.com/openfaas-incubator/openfaas-operator

COPY . .

RUN gofmt -l -d $(find . -type f -name '*.go' -not -path "./vendor/*") && \
  VERSION=$(git describe --all --exact-match `git rev-parse HEAD` | grep tags | sed 's/tags\///') && \
  GIT_COMMIT=$(git rev-list -1 HEAD) && \
  CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w \
  -X github.com/openfaas-incubator/openfaas-operator/pkg/version.Release=${VERSION} \
  -X github.com/openfaas-incubator/openfaas-operator/pkg/version.SHA=${GIT_COMMIT}" \
  -a -installsuffix cgo -o openfaas-operator .

FROM alpine:3.9

RUN addgroup -S app \
    && adduser -S -g app app \
    && apk --no-cache add ca-certificates

WORKDIR /home/app

COPY --from=0 /go/src/github.com/openfaas-incubator/openfaas-operator/openfaas-operator .

RUN chown -R app:app ./

USER app

ENTRYPOINT ["./openfaas-operator"]
CMD ["-logtostderr"]
