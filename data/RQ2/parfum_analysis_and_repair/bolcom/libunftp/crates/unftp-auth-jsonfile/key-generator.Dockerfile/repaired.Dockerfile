FROM alpine:latest

RUN apk add --no-cache bash openssl nettle-utils jq pwgen
COPY files/key-generator.sh /

ENTRYPOINT ["/key-generator.sh"]
