FROM golang:1.11.10

MAINTAINER Ivan Kozlovic <ivan@synadia.com>

COPY . /go/src/github.com/nats-io/nats-server
WORKDIR /go/src/github.com/nats-io/nats-server

RUN CGO_ENABLED=0 GO111MODULE=off GOOS=linux   GOARCH=amd64         go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w -X github.com/nats-io/nats-server/server.gitCommit=`git rev-parse --short HEAD`" -o pkg/linux-amd64/nats-server
RUN CGO_ENABLED=0 GO111MODULE=off GOOS=linux   GOARCH=arm   GOARM=6 go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w -X github.com/nats-io/nats-server/server.gitCommit=`git rev-parse --short HEAD`" -o pkg/linux-arm6/nats-server
RUN CGO_ENABLED=0 GO111MODULE=off GOOS=linux   GOARCH=arm   GOARM=7 go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w -X github.com/nats-io/nats-server/server.gitCommit=`git rev-parse --short HEAD`" -o pkg/linux-arm7/nats-server
RUN CGO_ENABLED=0 GO111MODULE=off GOOS=linux   GOARCH=arm64         go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w -X github.com/nats-io/nats-server/server.gitCommit=`git rev-parse --short HEAD`" -o pkg/linux-arm64/nats-server
RUN CGO_ENABLED=0 GO111MODULE=off GOOS=windows GOARCH=amd64         go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w -X github.com/nats-io/nats-server/server.gitCommit=`git rev-parse --short HEAD`" -o pkg/win-amd64/nats-server.exe

ENTRYPOINT ["go"]
CMD ["version"]
