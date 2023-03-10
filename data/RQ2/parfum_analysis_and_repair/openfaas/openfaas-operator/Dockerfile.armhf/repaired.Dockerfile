FROM golang:1.13

RUN mkdir -p /go/src/github.com/openfaas/openfaas-operator/

WORKDIR /go/src/github.com/openfaas/openfaas-operator

COPY . .

RUN gofmt -l -d $(find . -type f -name '*.go' -not -path "./vendor/*") && \
  VERSION=$(git describe --all --exact-match `git rev-parse HEAD` | grep tags | sed 's/tags\///') && \
  GIT_COMMIT=$(git rev-list -1 HEAD) && \
  CGO_ENABLED=0 GOOS=linux go build -ldflags "-s -w \
  -X github.com/openfaas/openfaas-operator/pkg/version.Release=${VERSION} \
  -X github.com/openfaas/openfaas-operator/pkg/version.SHA=${GIT_COMMIT}" \
  -a -installsuffix cgo -o openfaas-operator .

FROM alpine:3.11

RUN addgroup -S app \
    && adduser -S -g app app \
    && apk --no-cache add ca-certificates

WORKDIR /home/app

COPY --from=0 /go/src/github.com/openfaas/openfaas-operator/openfaas-operator .

RUN chown -R app:app ./

USER app

ENTRYPOINT ["./openfaas-operator"]