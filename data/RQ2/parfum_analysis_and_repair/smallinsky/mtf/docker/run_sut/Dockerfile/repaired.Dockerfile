FROM alpine:3.7

RUN apk update \
 && apk add --no-cache ca-certificates \
 && apk add --no-cache iptables \
 && apk add --no-cache tzdata


COPY docker_entrypoint.sh  docker_entrypoint.sh
RUN chmod +x docker_entrypoint.sh

ENTRYPOINT ["./docker_entrypoint.sh"]
