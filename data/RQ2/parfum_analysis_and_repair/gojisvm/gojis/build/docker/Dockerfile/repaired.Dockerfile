###################
## BUILDER IMAGE ##
###################

FROM golang:alpine AS builder

RUN apk update && apk add --no-cache git

RUN adduser -D -g '' matt

WORKDIR /var/build

COPY . .

RUN go mod download && go mod verify

RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /bin/gojis ./cmd/gojis

#################
## FINAL IMAGE ##
#################