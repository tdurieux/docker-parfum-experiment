FROM golang:1.12
LABEL maintainer="Kazumichi Yamamoto <yamamoto.febc@gmail.com>"
MAINTAINER Kazumichi Yamamoto <yamamoto.febc@gmail.com>

RUN  apt-get update && apt-get -y install bash git make zip && apt-get clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*
RUN go get -u github.com/motemen/gobump/cmd/gobump
ADD . /go/src/github.com/yamamoto-febc/terraform-provider-rke
WORKDIR /go/src/github.com/yamamoto-febc/terraform-provider-rke
CMD ["make"]
