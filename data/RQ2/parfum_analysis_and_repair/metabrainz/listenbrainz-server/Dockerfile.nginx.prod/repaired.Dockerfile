FROM nginx:1.13.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /etc
COPY ./docker/prod/nginx/nginx.conf /etc/nginx/conf.d/default.conf
