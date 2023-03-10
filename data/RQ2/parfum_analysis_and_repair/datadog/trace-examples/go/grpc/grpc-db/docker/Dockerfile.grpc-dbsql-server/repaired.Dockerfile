FROM golang:1.12 AS build
ADD cmd/grpc-dbsql-server/ /go/src/github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-dbsql-server/
ADD proto/ /go/src/github.com/DataDog/trace-examples/go/grpc/grpc-db/proto/
RUN go get -d github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-dbsql-server && go install github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-dbsql-server

FROM debian:stretch-slim
COPY --from=build /go/bin/grpc-dbsql-server /grpc-dbsql-server 
ENTRYPOINT ["/grpc-dbsql-server"]