FROM caddy:2.3.0-alpine

RUN apk update && apk add --no-cache jq gettext

COPY caddy_base.json /caddy_base.json
COPY entrypoint /entrypoint
COPY certs /certs

ENV ENABLE_LOCAL_HTTPS=1

ENTRYPOINT ["/entrypoint"]
CMD ["caddy", "run", "--config", "/etc/caddy/config.json"]