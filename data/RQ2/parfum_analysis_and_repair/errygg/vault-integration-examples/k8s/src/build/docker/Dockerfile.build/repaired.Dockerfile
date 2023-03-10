FROM golang:1.12.7
WORKDIR /go/src/github.com/hashicorp/app
ADD . .
RUN go get ./...
RUN CGO_ENABLED=0 GOOS=linux go build -a -o app .