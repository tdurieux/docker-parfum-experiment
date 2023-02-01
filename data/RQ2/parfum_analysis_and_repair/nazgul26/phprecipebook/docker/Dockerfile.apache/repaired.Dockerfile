FROM httpd:2.4.38 AS base

ARG version=5.1.5
ARG cv=0.2

ENV RecipebookRoot=/usr/local/apache2/htdocs/phprecipebook

ENV PHPRECIPEBOOK_DB_DATASOURCE="Database/Postgres"
ENV PHPRECIPEBOOK_DB_HOST="localhost"
ENV PHPRECIPEBOOK_DB_LOGIN="phprecipebook"
ENV PHPRECIPEBOOK_DB_PASS="df2cbf4a"
ENV PHPRECIPEBOOK_DB_NAME="phprecipebook"
#ENV PHPRECIPEBOOK_DB_ENCODING="utf8"

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update \
 && apt-get install -y --no-install-recommends php-gd php-mcrypt libapache2-mod-php && rm -rf /var/lib/apt/lists/*;

RUN \
    cd /tmp \
 && apt-get update && apt-get install -y --no-install-recommends ca-cacert curl \
 && curl --fail --location --output /tmp/phprecipebook.tar.gz https://github.com/nazgul26/PHPRecipebook/releases/download/${version}/phprecipebook-${version}.tar.gz   \
 && mkdir -p ${RecipebookRoot} \
 && tar -C ${RecipebookRoot} --strip-components=1 -xzpf /tmp/phprecipebook.tar.gz \
 && rm /tmp/phprecipebook.tar.gz \
 && apt-get remove -y --purge --auto-remove ca-cacert curl && rm -rf /var/lib/apt/lists/*;


RUN \
    chown -R root:www-data ${RecipebookRoot} \
 && chmod -R a-w ${RecipebookRoot} \
 && chown -R www-data:www-data ${RecipebookRoot}/tmp \
 && chmod -R u+rw ${RecipebookRoot}/tmp

COPY httpd.conf /usr/local/apache2/conf/httpd.conf
RUN \
    sed -i -e "s%PHPRECIPEBOOKROOT%${RecipebookRoot}%" /usr/local/apache2/conf/httpd.conf \
 && chown root:www-data /usr/local/apache2/conf/httpd.conf \
 && chmod 644 /usr/local/apache2/conf/httpd.conf


FROM base AS pgsql

LABEL software.version="${version}"
LABEL container.version="${cv}"

RUN \
     mkdir -p /usr/share/man/man1 /usr/share/man/man7 \
 && apt-get update && apt-get install -y --no-install-recommends php-pgsql postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY wait-for-postgres.sh php-rb-entrypoint.sh /usr/local/bin/
RUN chmod 555 /usr/local/bin/*

ENTRYPOINT [ "/usr/local/bin/php-rb-entrypoint.sh" ]
