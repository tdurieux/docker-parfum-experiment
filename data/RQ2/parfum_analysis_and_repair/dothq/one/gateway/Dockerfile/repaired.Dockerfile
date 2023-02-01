FROM caddy:2-alpine

COPY Caddyfile.prod /etc/caddy/Caddyfile

EXPOSE 80