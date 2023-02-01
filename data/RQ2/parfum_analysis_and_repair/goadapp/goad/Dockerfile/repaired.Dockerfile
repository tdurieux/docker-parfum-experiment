FROM golang:1.8.1-stretch

RUN apt-get update && apt-get install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;
ADD . /go/src/github.com/goadapp/goad
WORKDIR /go/src/github.com/goadapp/goad
RUN go get -u github.com/jteeuwen/go-bindata/...
RUN make linux64
RUN go build -o /go/bin/goad-api webapi/webapi.go

CMD ["/go/bin/goad-api", "-addr", ":8080"]
EXPOSE 8080
