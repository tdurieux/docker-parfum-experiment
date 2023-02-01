FROM golang:1.15-alpine

WORKDIR /go/src/app
COPY . .

RUN go get -d -v ./
RUN go get -u github.com/swaggo/swag/cmd/swag && $GOPATH/bin/swag init
RUN apk add --no-cache make && make

RUN apk add --no-cache curl && ( curl -f -L https://github.com/golang-migrate/migrate/releases/download/v4.14.1/migrate.linux-amd64.tar.gz | tar xvz)

EXPOSE 8080
CMD ["./main"]
