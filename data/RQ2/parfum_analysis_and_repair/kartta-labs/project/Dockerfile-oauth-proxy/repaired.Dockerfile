# docker build -t oauth-proxy:latest -f Dockerfile .

FROM golang:1.14-alpine3.11

RUN apk update && apk add --no-cache git && apk add --no-cache gettext

RUN mkdir /src
RUN cd /src && go mod init github.com/my/repo #  (initializes module system?)
RUN cd /src && go get github.com/oauth2-proxy/oauth2-proxy #  (⇒ ~/go/bin/oauth2-proxy)

# this entrypoint will be overridden by docker-compose or k8s config
ENTRYPOINT ["tail", "-f", "/dev/null"]

