FROM voxxit/base:alpine

RUN apk add --no-cache --update goaccess \
  && rm -rf /var/cache/apk/*

ENTRYPOINT [ "goaccess" ]
