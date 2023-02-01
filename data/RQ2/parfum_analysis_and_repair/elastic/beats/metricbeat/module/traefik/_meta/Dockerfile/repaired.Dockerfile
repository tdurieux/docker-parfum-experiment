ARG TRAEFIK_VERSION
FROM traefik:${TRAEFIK_VERSION}-alpine

COPY ./traefik.toml /etc/traefik/traefik.toml

RUN apk add --no-cache curl
HEALTHCHECK CMD [ curl -f https://localhost:8080/health]
