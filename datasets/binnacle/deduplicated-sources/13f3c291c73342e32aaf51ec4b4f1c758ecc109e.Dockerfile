FROM  golang:1.11.5

COPY . /go/src/github.com/cpuguy83/docker-log-driver
RUN cd /go/src/github.com/cpuguy83/docker-log-driver && go get && go build --ldflags '-extldflags "-static"' -o /usr/bin/docker-log-driver