FROM golang

#Install git
RUN apt-get update; apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /go/src/github.com/degenerat3/
RUN cd /go/src/github.com/degenerat3; git clone https://github.com/degenerat3/meteor;
WORKDIR /go/src/github.com/degenerat3/meteor
RUN go mod tidy
RUN cd /go/src/github.com/degenerat3/meteor/listeners/little_foot; CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o little_foot .

FROM alpine:latest 
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=0 /go/src/github.com/degenerat3/meteor/listeners/little_foot .
CMD ["./little_foot"]