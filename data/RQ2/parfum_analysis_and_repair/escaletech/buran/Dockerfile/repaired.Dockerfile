FROM alpine

RUN apk update && apk add --no-cache ca-certificates tzdata && rm -rf /var/cache/apk/*

WORKDIR /app

COPY ./dist/buran /app

CMD ["/app/buran"]