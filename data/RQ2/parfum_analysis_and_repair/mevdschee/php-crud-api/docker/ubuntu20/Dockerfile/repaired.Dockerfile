FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

# install: php / mysql / postgres / sqlite / tools / mssql deps
RUN apt-get update && apt-get -y --no-install-recommends install \
php-cli php-xml php-mbstring \
mysql-server mysql-client php-mysql \
postgresql php-pgsql \
postgresql-12-postgis-3 \
sqlite3 php-sqlite3 \
git wget \
curl gnupg && rm -rf /var/lib/apt/lists/*;

# adding custom MS repository
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl -f https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/msprod.list
RUN curl -f https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list > /etc/apt/sources.list.d/mssql-server-2019.list

# install SQL Server and tools
RUN apt-get update && apt-get -y --no-install-recommends install mssql-server && rm -rf /var/lib/apt/lists/*;
RUN ACCEPT_EULA=Y MSSQL_PID=Express MSSQL_SA_PASSWORD=sapwd123! /opt/mssql/bin/mssql-conf setup || true
RUN ACCEPT_EULA=Y apt-get --no-install-recommends install -y msodbcsql17 mssql-tools && rm -rf /var/lib/apt/lists/*;

# install pdo_sqlsrv
RUN apt-get -y --no-install-recommends install php-pear build-essential unixodbc-dev php-dev && rm -rf /var/lib/apt/lists/*;
RUN pecl install pdo_sqlsrv
RUN echo extension=pdo_sqlsrv.so > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
RUN phpenmod pdo_sqlsrv

# install locales
RUN apt-get -y --no-install-recommends install locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# install run script
ADD run.sh /usr/sbin/docker-run
CMD docker-run
