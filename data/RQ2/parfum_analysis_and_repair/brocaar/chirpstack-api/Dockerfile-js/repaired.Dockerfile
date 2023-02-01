FROM golang:1.14-alpine AS go-requirements-base

ENV PROJECT_PATH=/chirpstack-api
RUN apk add --no-cache make git

RUN mkdir -p $PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH/go
RUN make requirements

RUN cp -r $(go list -f '{{ .Dir }}' github.com/grpc-ecosystem/grpc-gateway/protoc-gen-grpc-gateway)/../third_party/googleapis /googleapis

FROM node:12

ENV PROJECT_PATH=/chirpstack-api
RUN apt update && apt install --no-install-recommends -y protobuf-compiler libprotobuf-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p $PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH

COPY --from=go-requirements-base /googleapis /googleapis
