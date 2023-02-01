FROM postgres:9.6.1

MAINTAINER Sasa Macakanja <sasa.macakanja@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-contrib && rm -rf /var/lib/apt/lists/*;

ADD createExtension.sh /docker-entrypoint-initdb.d/
RUN chmod 755 /docker-entrypoint-initdb.d/createExtension.sh
