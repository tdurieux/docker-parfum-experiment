FROM ubuntu:vivid
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y update && apt-get -y --no-install-recommends install postgresql-client php5-cli php5-pgsql php5-mssql vim unixodbc unixodbc-dev unixodbc-bin libodbc1 odbcinst1debian2 tdsodbc php5-odbc freetds-bin freetds-common freetds-dev libct4 libsybdb5 && rm -rf /var/lib/apt/lists/*;

ADD config/odbcinst.ini /etc/odbcinst.ini
ADD config/odbc.ini /etc/odbc.ini
ADD config/freetds.conf /etc/freetds/freetds.conf
ADD mssql2pgsql /mssql2pgsql
RUN chmod +x /mssql2pgsql