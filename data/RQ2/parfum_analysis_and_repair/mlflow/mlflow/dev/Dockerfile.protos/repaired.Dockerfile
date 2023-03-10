# How to build protobuf files using this Dockerfile:
# $ pushd dev
# $ DOCKER_BUILDKIT=1 docker build -t gen-protos -f Dockerfile.protos .
# $ popd
# $ docker run --rm -v $(pwd):/app gen-protos ./dev/generate-protos.sh

FROM ubuntu:20.04

WORKDIR /app

RUN apt-get update --yes && apt-get install --no-install-recommends curl unzip --yes && rm -rf /var/lib/apt/lists/*;
RUN curl -f -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.19.4/protoc-3.19.4-linux-x86_64.zip
RUN unzip protoc-3.19.4-linux-x86_64.zip -d /tmp/protoc
ENV PATH="/tmp/protoc/bin:${PATH}"
RUN protoc --version
