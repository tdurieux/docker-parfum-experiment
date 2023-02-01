FROM ubuntu:16.04
MAINTAINER Dmitry Veselov <d.a.veselov@yandex.ru>

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:libreoffice/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y golang git curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreoffice libreofficekit-dev && rm -rf /var/lib/apt/lists/*;

ENV GOPATH /go

RUN mkdir /go
ADD . /go/src/github.com/docsbox/go-libreofficekit
WORKDIR /go/src/github.com/docsbox/go-libreofficekit
RUN echo "go test -race -coverprofile=coverage.txt -covermode=atomic && bash <(curl -s https://codecov.io/bash) -t 473da5a7-66ec-45dc-b4ed-eb758ce8a66b" > test.sh
