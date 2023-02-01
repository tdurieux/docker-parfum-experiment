FROM vipconsult/base:jessie
MAINTAINER Vip Consult Solutions <team@vip-consult.solutions>

# Set the locale
RUN echo deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main >> /etc/apt/sources.list && \
    apt-get update

RUN apt-get install locales && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.conf && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

RUN apt-get install postgresql-client-9.6 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/psql"]
