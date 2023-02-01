FROM alpine:3.11.6

RUN apk update
RUN apk add --no-cache mysql mysql-client
COPY setup.sh /tmp/

EXPOSE 3306

ENTRYPOINT ["/tmp/setup.sh"]
