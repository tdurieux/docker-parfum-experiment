# Build stage
FROM golang:1.11.0-stretch as builder
WORKDIR /dir
COPY app.go .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .

# Run stage