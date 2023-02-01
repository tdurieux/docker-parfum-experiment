#
# Build go project
#
FROM golang:1.15-alpine as go-builder

WORKDIR /go/src/github.com/wardviaene/kubernetes-course/mutatingwebhook

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mutatingwebhook *.go

#
# Runtime container
#