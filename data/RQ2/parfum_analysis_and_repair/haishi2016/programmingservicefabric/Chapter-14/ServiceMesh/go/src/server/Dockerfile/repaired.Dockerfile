FROM golang

ADD . /go/src/server
RUN apt-get update && apt-get -y --no-install-recommends install dnsutils && rm -rf /var/lib/apt/lists/*;
RUN go get github.com/lib/pq
RUN go install server

WORKDIR /go/src/server
CMD ["go", "run", "server.go"]

EXPOSE 8084
