FROM ubuntu:xenial

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  nginx \
  nginx-extras \
  && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf

CMD nginx -g "daemon off;"