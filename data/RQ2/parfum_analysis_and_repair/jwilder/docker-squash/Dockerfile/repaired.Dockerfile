FROM golang:1.4

RUN apt-get update && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

COPY . /go/src/github.com/jwilder/docker-squash
RUN go get github.com/jwilder/docker-squash

ENTRYPOINT ["docker-squash"]
