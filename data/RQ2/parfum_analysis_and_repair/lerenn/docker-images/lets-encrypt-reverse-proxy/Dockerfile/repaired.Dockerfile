FROM debian:stretch
MAINTAINER Louis Fradin <louis.fradin@gmail.com>

# Update distrib
RUN apt-get update && apt-get install --no-install-recommends -y nginx dnsmasq certbot curl && rm -rf /var/lib/apt/lists/*; # Install certbot and nginx


# Copy files
COPY docker /docker

# Copy configuration files
RUN cp /docker/config/nginx.conf /etc/nginx/ && \
    cp /docker/config/proxy.conf /etc/nginx/conf.d/

# Volumes
VOLUME /etc/nginx/sites-enabled
VOLUME /etc/letsencrypt

# Environment variables
ENV LETSENCRYPT_EMAIL none
ENV RSA_KEY_SIZE 4096
ENV STARTUP_WAIT 0

# Ports
EXPOSE 80
EXPOSE 443

# Command and healthcheck
CMD ["bash", "/docker/scripts/entrypoint.sh" ]
HEALTHCHECK CMD curl --fail http://localhost || exit 1
