FROM golang:1.12.4-alpine

# disable cgo to avoid gcc requirement bug
ENV CGO_ENABLED=0

RUN apk update && apk --update add --no-cache git entr

RUN mkdir /app
WORKDIR /app

CMD ["./bin/boot-dev.sh"]