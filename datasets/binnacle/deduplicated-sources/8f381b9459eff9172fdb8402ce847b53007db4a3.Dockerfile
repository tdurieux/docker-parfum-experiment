# Build stage
FROM golang:1.10.4 as build

RUN mkdir -p /go/src/github.com/openfaas/faas-swarm/

WORKDIR /go/src/github.com/openfaas/faas-swarm

COPY . .

#RUN curl -sL https://github.com/alexellis/license-check/releases/download/0.2.2/license-check > /usr/bin/license-check \
#    && chmod +x /usr/bin/license-check
#RUN license-check -path ./ --verbose=false "Alex Ellis" "OpenFaaS Author(s)"

RUN gofmt -l -d $(find . -type f -name '*.go' -not -path "./vendor/*") \
  && go test $(go list ./... | grep -v /vendor/) -cover \
  && VERSION=$(git describe --all --exact-match `git rev-parse HEAD` | grep tags | sed 's/tags\///') \
  && GIT_COMMIT=$(git rev-list -1 HEAD) \
  && CGO_ENABLED=0 GOOS=linux go build --ldflags "-s -w \
  -X github.com/openfaas/faas-swarm/version.GitCommit=${GIT_COMMIT}\
  -X github.com/openfaas/faas-swarm/version.Version=${VERSION}" \
  -a -installsuffix cgo -o faas-swarm .

# Release stage
FROM alpine:3.8

RUN apk --no-cache add ca-certificates

WORKDIR /root/

EXPOSE 8080

ENV http_proxy      ""
ENV https_proxy     ""

COPY --from=build /go/src/github.com/openfaas/faas-swarm/faas-swarm    .

CMD ["./faas-swarm"]
