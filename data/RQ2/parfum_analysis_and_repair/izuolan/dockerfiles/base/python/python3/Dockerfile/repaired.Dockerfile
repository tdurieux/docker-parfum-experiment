FROM alpine:edge
RUN apk update && apk upgrade \
  && apk add --no-cache ca-certificates python3 \
  && rm -rf /var/cache/apk/*
