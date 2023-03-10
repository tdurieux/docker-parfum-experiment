FROM traefik:1.6-alpine

COPY ./traefik.toml /etc/traefik/traefik.toml

RUN apk add --no-cache curl
HEALTHCHECK --interval=1s --retries=90 CMD curl -f http://localhost:8080/health