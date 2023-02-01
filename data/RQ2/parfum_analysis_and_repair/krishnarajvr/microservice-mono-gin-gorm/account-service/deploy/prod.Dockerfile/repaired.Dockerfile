# Build environment
# -----------------
FROM golang:1.15-alpine as build-env
WORKDIR /micro

RUN apk update && apk add --no-cache gcc musl-dev git

COPY go.mod go.sum ./

RUN go mod download

RUN go get -u github.com/swaggo/swag/cmd/swag \
       && go get -u github.com/vektra/mockery/cmd/mockery 

RUN pwd

COPY . .

RUN go mod vendor \
       && swag init -g module/module.go -o doc 

RUN go build -ldflags '-w -s' -a -o ./bin/api ./cmd/api \
    && go build -ldflags '-w -s' -a -o ./bin/migrate ./cmd/migrate


# Deployment environment
# ----------------------