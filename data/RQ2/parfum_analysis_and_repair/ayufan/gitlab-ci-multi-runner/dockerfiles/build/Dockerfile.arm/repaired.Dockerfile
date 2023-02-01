FROM scaleway/alpine

RUN apk add --no-cache --update bash ca-certificates git
COPY ./ /usr/bin
