# build stage
FROM golang:alpine AS build-env
RUN apk update
RUN apk add --no-cache git

WORKDIR /go/src/github.com/smallstep/autocert/examples/hello-mtls/go-grpc
ADD server/server.go .
COPY hello hello
RUN go get -d -v ./...
RUN go build -o server

# final stage
FROM alpine
COPY --from=build-env /go/src/github.com/smallstep/autocert/examples/hello-mtls/go-grpc/server .
CMD ["./server"]
