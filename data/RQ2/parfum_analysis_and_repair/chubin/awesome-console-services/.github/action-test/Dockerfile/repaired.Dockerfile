FROM alpine:latest

LABEL version="0.0.1"
LABEL maintainer="David Adi Nugroho <davidadi216@gmail.com>"

RUN apk add --no-cache bash
RUN apk add --no-cache curl
RUN apk add --no-cache netcat-openbsd

COPY entrypoint.sh /usr/local/bin/entrypoint

RUN chmod +x /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/local/bin/entrypoint"]