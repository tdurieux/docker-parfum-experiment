FROM golang:1.13-alpine
ENV maintainer=ztao8607@gmail.com
COPY repositories /etc/apk/repositories
RUN apk update && \
    apk add --no-cache build-base