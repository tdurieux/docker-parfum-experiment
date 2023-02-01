FROM alpine:edge

RUN apk update && apk upgrade \
  && apk add --no-cache ca-certificates libstdc++ \
  && rm -rf /var/cache/apk/*