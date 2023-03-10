# Start by building the application.
# Criando build em stopservicedocker com distroless
FROM golang:1.11 as builder
RUN go get -u github.com/lib/pq
WORKDIR /go/src/stopservicedocker
COPY . .

# RUN go get -d -v ./...
RUN go install -v ./...

# Now copy it into our base image.