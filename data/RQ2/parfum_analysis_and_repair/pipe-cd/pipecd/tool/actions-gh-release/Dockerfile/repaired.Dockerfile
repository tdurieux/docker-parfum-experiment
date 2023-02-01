FROM golang:1.17.6-alpine3.15

RUN apk update && apk add --no-cache git

COPY . /app

RUN cd /app && \
  go build -o /gh-release . && \
  chmod +x /gh-release

ENTRYPOINT ["/gh-release"]
