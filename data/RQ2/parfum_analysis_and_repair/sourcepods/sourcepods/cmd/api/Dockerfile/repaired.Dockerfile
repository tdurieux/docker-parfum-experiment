FROM alpine

RUN apk add --no-cache --update ca-certificates

COPY ./dev/api /usr/bin/
COPY ./schema/postgres /migrations

EXPOSE 3020

ENTRYPOINT ["/usr/bin/api"]
