FROM alpine:3.12
MAINTAINER Rohith <gambol99@gmail.com>

RUN apk update && \
    apk add --no-cache ca-certificates bash

RUN adduser -D vault

ADD bin/vault-sidekick /vault-sidekick
RUN chmod 755 /vault-sidekick

USER vault

ENTRYPOINT [ "/vault-sidekick" ]
