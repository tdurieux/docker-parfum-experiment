FROM golang:alpine

RUN apk update
RUN apk upgrade
RUN apk add --no-cache alpine-sdk git upx

ENV GOPATH /usr/local
ADD ./ /usr/local/src/github.com/tiancaiamao/shen-go
WORKDIR /usr/local/src/github.com/tiancaiamao/shen-go
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags '-extldflags "-static"' -o shen cmd/shen/*.go
RUN upx -9 --ultra-brute ./shen
RUN install ./shen /usr/local/bin/
