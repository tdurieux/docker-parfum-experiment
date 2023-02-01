FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        apache2 \
        libapache2-mod-php \
        libapache2-mod-auth-openidc \
        php-cli \
        curl && rm -rf /var/lib/apt/lists/*;

RUN rm -rf /var/www/html/*
COPY index.php /var/www/html/
COPY entry.sh /entry.sh
RUN chmod +x /entry.sh

COPY flag /flag
RUN chmod 404 /flag

EXPOSE 80

ENTRYPOINT ["/entry.sh"]
