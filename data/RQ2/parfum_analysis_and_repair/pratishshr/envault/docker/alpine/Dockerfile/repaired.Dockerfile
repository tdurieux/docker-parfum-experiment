FROM alpine:latest

RUN apk add --no-cache --update \
    && apk --no-cache add curl \
    && curl -sf https://raw.githubusercontent.com/pratishshr/envault/master/install.sh | sh