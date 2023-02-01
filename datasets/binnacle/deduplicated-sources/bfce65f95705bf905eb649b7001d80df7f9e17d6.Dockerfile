FROM golang:1.11 AS build
ADD . /src
WORKDIR /src
RUN go get -d -v -t
RUN go test --cover -v ./...
RUN go build -v -o go-demo

EXPOSE 8080
ENV DB db
CMD ["go-demo"]
HEALTHCHECK --interval=10s CMD wget -qO- localhost:8080/demo/hello

RUN mv go-demo /usr/local/bin/go-demo
RUN chmod +x /usr/local/bin/go-demo
