FROM alpine:3

ENV PROJECT_PATH=/chirpstack/api
RUN apk add --no-cache protobuf protobuf-dev make bash git

RUN git clone https://github.com/googleapis/googleapis.git /googleapis

ADD https://github.com/grpc/grpc-web/releases/download/1.2.1/protoc-gen-grpc-web-1.2.1-linux-x86_64 /usr/bin/protoc-gen-grpc-web
RUN chmod +x /usr/bin/protoc-gen-grpc-web

RUN mkdir -p $PROJECT_PATH
WORKDIR $PROJECT_PATH