ARG VERSION=latest

FROM docker:${VERSION}

RUN apk add --no-cache --update make