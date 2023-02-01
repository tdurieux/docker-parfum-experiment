# Build pysssix driver
FROM golang:1.9.2

COPY drivers/pysssix/main.go /go
RUN go build /go/main.go


# Build goofys driver
FROM golang:1.9.2

COPY drivers/goofys/main.go /go
RUN go build /go/main.go


# Build deployment container