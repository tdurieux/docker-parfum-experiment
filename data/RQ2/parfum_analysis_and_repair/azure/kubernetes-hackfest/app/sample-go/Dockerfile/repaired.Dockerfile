# build stage
FROM golang:1.13.1 AS build-env
WORKDIR /go/src/app
ADD . .
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# final stage