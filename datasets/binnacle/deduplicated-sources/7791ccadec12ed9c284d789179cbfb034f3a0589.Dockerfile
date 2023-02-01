FROM golang:1.9.1
WORKDIR /go/src/github.com/crunchydata/sample-app
ADD tools/sample-app/ .
RUN CGO_ENABLED=0 GOOS=linux go build -a -o sample-app .
