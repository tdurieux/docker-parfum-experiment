FROM  tianon/debian:jessie
MAINTAINER Steve Gattuso "http://stevegattuso.me"

ENV GOBB_PATH /gobb
ENV GOPATH /go

RUN apt-get update && apt-get install --no-install-recommends -y git golang build-essential && rm -rf /var/lib/apt/lists/*;
RUN mkdir /go
RUN go get github.com/stevenleeg/gobb/gobb

EXPOSE 8000
VOLUME "/gobb/config"
CMD ["/go/bin/gobb", "-config", "/gobb/config/gobb.conf", "--migrate"]
