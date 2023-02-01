FROM nginx:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/www
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./dist/. /var/www
COPY docker-external-config.json /var/www/docker-external-config.json

HEALTHCHECK CMD [ curl --fail https://localhost/health || exit 1]