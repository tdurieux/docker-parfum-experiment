FROM php:7.3-apache

RUN apt update && apt install --no-install-recommends libxml2-dev libcurl4-gnutls-dev --yes && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends vim --yes && rm -rf /var/lib/apt/lists/*;

COPY .docker/entrypoint.sh /opt/

RUN mkdir /opt/solr2

WORKDIR /opt/solr2

ENTRYPOINT ["sh","/opt/entrypoint.sh"]