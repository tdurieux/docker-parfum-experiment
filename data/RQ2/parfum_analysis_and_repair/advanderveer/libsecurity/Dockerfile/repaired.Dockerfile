FROM golang:1.4
MAINTAINER jerbia@gmail.com

RUN go get github.com/fsouza/go-dockerclient
RUN go get github.com/ChimeraCoder/anaconda
RUN go get github.com/hashicorp/errwrap
run echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y socat jq docker.io && rm -rf /var/lib/apt/lists/*;

COPY . /go/src/github.com/advanderveer/docksec
WORKDIR /go/src/github.com/advanderveer/docksec
RUN go build -v

CMD /go/src/github.com/advanderveer/docksec/docksec
