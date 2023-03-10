# build stage
FROM golang:alpine AS build-env
RUN apk update
RUN apk add --no-cache git
RUN mkdir /src

WORKDIR /go/src/github.com/smallstep/autocert/examples/hello-mtls/go-grpc
ADD client/client.go .
COPY hello hello
RUN go get -d -v ./...
RUN go build -o client

# final stage
FROM alpine
COPY --from=build-env /go/src/github.com/smallstep/autocert/examples/hello-mtls/go-grpc/client .
CMD ["./client"]
