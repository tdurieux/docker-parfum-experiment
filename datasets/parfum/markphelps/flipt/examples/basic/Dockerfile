ARG GO_VERSION=1.17

FROM golang:${GO_VERSION}-alpine

RUN apk update && apk add --no-cache git

WORKDIR /example
COPY . .

RUN go get "go.flipt.io/grpc-go" \
    "google.golang.org/grpc"

ENTRYPOINT ["go", "run", "-tags", "example", "main.go"]
