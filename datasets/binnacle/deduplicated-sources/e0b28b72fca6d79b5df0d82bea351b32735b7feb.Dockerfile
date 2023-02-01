FROM golang:1.3-cross
RUN go get github.com/tools/godep
ADD . /go/src/github.com/shipyard/shipyard-deploy
ADD https://get.docker.com/builds/Linux/x86_64/docker-1.5.0 /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker
WORKDIR /go/src/github.com/shipyard/shipyard-deploy

