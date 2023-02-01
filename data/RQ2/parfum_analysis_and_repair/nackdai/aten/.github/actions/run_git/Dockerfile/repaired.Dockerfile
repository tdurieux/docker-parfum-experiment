FROM alpine:latest

RUN apk add --no-cache --update bash git git-subtree

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
