FROM golang:1.9.4

COPY . /go/src/outyet
WORKDIR /go/src/outyet

ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go get -v -d && \
    go install -v && \
    go test -v && \
    go build -ldflags "-s" -a -installsuffix cgo -o outyet .

RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN cp /go/src/outyet/outyet .

EXPOSE 18088

CMD ["/outyet", "-version", "1.9.4", "-poll", "600s", "-http", ":18088"]

