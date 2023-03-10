# https://blog.codeship.com/building-minimal-docker-containers-for-go-applications
FROM alpine:latest

RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
ADD .docker/passwd.nobody /etc/passwd

ADD .docker/anycable-go-linux-amd64 /usr/local/bin/anycable-go

USER nobody

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/anycable-go"]
