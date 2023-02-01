# Dockerfile used to build a build step that builds container-structure-test in CI.
FROM golang:1.17
RUN apt-get update && apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /go/src/github.com/GoogleContainerTools
RUN ln -s /workspace /go/src/github.com/GoogleContainerTools/container-structure-test
WORKDIR /go/src/github.com/GoogleContainerTools/container-structure-test
