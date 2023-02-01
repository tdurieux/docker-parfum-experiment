##### sdk image #####
FROM golang:1.16-alpine AS sdk

WORKDIR /go/src/github.com/hobbyfarm/gargantua
COPY . .

ENV GOOS=linux 
ENV CGO_ENABLED=0

RUN go get -d -v ./...

RUN go install -v ./...

RUN ls -lart && go build -o /go/bin/gargantua main.go
###### release image #####