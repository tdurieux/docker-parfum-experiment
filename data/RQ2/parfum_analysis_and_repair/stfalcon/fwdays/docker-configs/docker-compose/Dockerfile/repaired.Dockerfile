FROM docker/compose
RUN apk update && apk add --no-cache ca-certificates && rm -rf /var/cache/apk/*
