FROM traefik:1.6-alpine

COPY ./traefik.toml /etc/traefik/traefik.toml

RUN apk add --no-cache curl
HEALTHCHECK CMD [ curl -f https://localhost:8080/health]
