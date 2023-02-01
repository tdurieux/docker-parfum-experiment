FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive

# install: php / mysql / postgres / sqlite / tools / mssql deps
RUN apt-get update && apt-get -y --no-install-recommends install \
php-cli php-xml php-mbstring \
mysql-server mysql-client php-mysql \
postgresql php-pgsql \
postgresql-14-postgis-3 \
sqlite3 php-sqlite3 \
git wget \
curl gnupg && rm -rf /var/lib/apt/lists/*;

# install locales
RUN apt-get -y --no-install-recommends install locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# install run script
ADD run.sh /usr/sbin/docker-run
CMD docker-run
