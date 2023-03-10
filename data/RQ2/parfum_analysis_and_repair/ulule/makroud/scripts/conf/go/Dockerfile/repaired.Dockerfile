FROM golang:1-buster

MAINTAINER thomas@leroux.io

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

RUN apt-get -y update \
    && apt-get upgrade -y \
    && apt-get -y --no-install-recommends install git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -ms /bin/bash gopher

COPY go.mod go.sum /media/ulule/makroud/
RUN chown -R gopher:gopher /media/ulule/makroud
ENV GOPATH /home/gopher/go
ENV PATH $GOPATH/bin:$PATH
USER gopher

RUN GO111MODULE=on go get github.com/golangci/golangci-lint/cmd/golangci-lint@v1.27.0

WORKDIR /media/ulule/makroud
RUN go mod download
COPY --chown=gopher:gopher . /media/ulule/makroud

CMD [ "/bin/bash" ]
