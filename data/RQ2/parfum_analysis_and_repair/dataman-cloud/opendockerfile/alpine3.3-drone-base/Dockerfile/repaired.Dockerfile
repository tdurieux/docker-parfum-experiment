FROM demoregistry.dataman-inc.com/library/alpine3.3-base:latest

RUN apk add --no-cache -U ca-certificates git openssh curl perl subversion && rm -rf /var/cache/apk/*
