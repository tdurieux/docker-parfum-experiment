FROM debian:9

USER root

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y nginx \
    ca-certificates && rm -rf /var/lib/apt/lists/*;

WORKDIR /var/app

# Set up configuration volumes
RUN mkdir -p /etc/config

WORKDIR /var/app

CMD sh /var/app/containers/nginx/entrypoint.sh
