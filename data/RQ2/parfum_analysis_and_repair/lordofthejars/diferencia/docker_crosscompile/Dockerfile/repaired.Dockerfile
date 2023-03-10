FROM golang:1.10.8-alpine3.9

MAINTAINER Alex Soto <asotobu@gmail.com>

RUN apk update && apk upgrade && \
    apk add --no-cache git

RUN wget https://github.com/gobuffalo/packr/releases/download/v1.11.1/packr_1.11.1_linux_amd64.tar.gz
RUN tar -zxvf packr_1.11.1_linux_amd64.tar.gz && rm packr_1.11.1_linux_amd64.tar.gz
RUN cp packr /usr/local/bin

RUN go get -u github.com/golang/dep/cmd/dep

ADD crossbuild.sh /usr/local/bin/crossbuild.sh
RUN chmod 755 /usr/local/bin/crossbuild.sh