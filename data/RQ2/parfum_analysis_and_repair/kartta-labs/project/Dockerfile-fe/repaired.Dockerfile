# docker build -t fe:latest -f Dockerfile-fe .

FROM debian:buster-slim

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends logrotate nginx-full gettext-base && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv

COPY ./public /srv/public
COPY ./kscope /srv/kscope

RUN chmod -R a+rx /srv

ENTRYPOINT ["nginx", "-g", "daemon off;"]
