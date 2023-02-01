FROM golang:1.18 as builder
ENV GOARCH=amd64

COPY ./main.go /go/src/github.com/kmlebedev/txmlconnector/main.go
COPY ./client /go/src/github.com/kmlebedev/txmlconnector/client
COPY ./examples/grpc-client /go/src/github.com/kmlebedev/txmlconnector/examples/grpc-client
COPY ./server /go/src/github.com/kmlebedev/txmlconnector/server
COPY ./proto /go/src/github.com/kmlebedev/txmlconnector/proto
COPY ./go.mod /go/src/github.com/kmlebedev/txmlconnector/go.mod
COPY ./go.sum /go/src/github.com/kmlebedev/txmlconnector/go.sum

WORKDIR /go/src/github.com/kmlebedev/txmlconnector

RUN apk add --no-cache --virtual build-dependencies --update mingw-w64-gcc gcc libc-dev musl-dev && \
    go mod download && \
    GOOS=windows CGO_ENABLED=1 CC="x86_64-w64-mingw32-gcc" CXX="x86_64-w64-mingw32-g++" GOOS=windows GOARCH=amd64 go build -race -ldflags "-extldflags -static -s -w" -o /go/bin/server.exe main.go && \
    GOOS=linux CGO_ENABLED=0 go build -ldflags "-extldflags -static" -o /go/bin/client examples/grpc-client/main.go

FROM ubuntu:22.04 AS final

ENV TC_DLL_VER=6.19.2.21.16
COPY --from=builder /go/bin/server.exe /usr/bin/txmlconnector-server.exe
COPY --from=builder /go/bin/client /usr/bin/txmlconnector-client
COPY ./txmlconnector64-${TC_DLL_VER}.dll /usr/bin/
COPY ./docker/entrypoint.sh /entrypoint.sh

ENV TC_DLL_PATH=/usr/bin/txmlconnector64-${TC_DLL_VER}.dll

RUN mkdir logs && \
    apt-get update && \
    apt-get install -y --no-install-recommends wine64 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# server gprc port
EXPOSE 50051

ENTRYPOINT ["/entrypoint_ubuntu.sh"]