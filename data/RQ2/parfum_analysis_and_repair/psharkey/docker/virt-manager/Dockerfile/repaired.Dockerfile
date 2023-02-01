FROM alpine:3.4

RUN apk --update --no-cache add \
         libxext \
         libxtst \
         libxrender \
         virt-manager \
    && rm -rf /var/cache/apk/*
