FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get -y --no-install-recommends install \
        apache2 \
        nano \
    && a2enmod rewrite \
    && a2enmod ssl \
    && a2enmod cgi \
    && a2enmod headers && rm -rf /var/lib/apt/lists/*;

CMD service apache2 start && tail -f /dev/null

