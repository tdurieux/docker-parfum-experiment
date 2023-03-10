FROM golang:1.12 AS build
ADD cmd/grpc-db-client/ /go/src/github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-db-client/
ADD proto/ /go/src/github.com/DataDog/trace-examples/go/grpc/grpc-db/proto/
RUN go get -d github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-db-client && go install github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-db-client

FROM debian:stretch-slim
COPY --from=build /go/bin/grpc-db-client /grpc-db-client 
ENTRYPOINT ["/grpc-db-client"]