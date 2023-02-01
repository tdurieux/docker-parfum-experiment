FROM golang:1.16 as builder
RUN mkdir /go/src/gotrain
WORKDIR /go/src/gotrain
COPY . .

RUN apt-get update -y
RUN apt-get -y --no-install-recommends install libzmq3-dev && rm -rf /var/lib/apt/lists/*;
RUN go get
RUN go build -o /go/bin/gotrain

EXPOSE 8080

FROM debian
RUN apt-get update -y
RUN apt-get -y --no-install-recommends install libzmq3-dev && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /go/bin/gotrain /app/gotrain
WORKDIR /
RUN mkdir data
RUN chmod +x /app/gotrain
CMD ["/app/gotrain", "server"]