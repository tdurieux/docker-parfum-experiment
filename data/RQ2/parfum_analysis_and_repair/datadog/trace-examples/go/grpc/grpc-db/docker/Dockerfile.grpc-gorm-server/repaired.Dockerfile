FROM golang:1.12 AS build
ADD cmd/grpc-gorm-server/ /go/src/github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-gorm-server/
ADD proto/ /go/src/github.com/DataDog/trace-examples/go/grpc/grpc-db/proto/
RUN go get -d github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-gorm-server && go install github.com/DataDog/trace-examples/go/grpc/grpc-db/cmd/grpc-gorm-server

FROM debian:stretch-slim
COPY --from=build /go/bin/grpc-gorm-server /grpc-gorm-server 
ENTRYPOINT ["/grpc-gorm-server"]