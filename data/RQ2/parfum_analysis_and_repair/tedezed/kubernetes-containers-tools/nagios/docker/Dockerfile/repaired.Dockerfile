FROM httpd:latest
MAINTAINER Juan Manuel Torres <juanmanuel.torres@aventurabinaria.es>

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
	&& apt-get install --no-install-recommends -y nagios3 nagios-nrpe-server nagios-nrpe-plugin nagios-plugins && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
	&& apt-get install --no-install-recommends -y wget nano git unzip apache2-utils mysql-client \
		libmysqlclient-dev libdbd-mysql-perl build-essential make automake \
  && a2enmod rewrite \
  && a2enmod cgi && rm -rf /var/lib/apt/lists/*;

ENV NAGIOS_DIR="/usr/local/nagios" \
	NAGIOS_USER="nagios" \
	NAGIOS_PASS="nagios" \
	NAGIOS_DEBUG="OFF" \
	MYSQL_USER="nagios" \
	MYSQL_PASSWORD="nagios" \
	MYSQL_HOST="mysql" \
	MYSQL_DATABASE="nagios"

RUN cd /tmp \
    && wget -O ndoutils.tar.gz https://github.com/NagiosEnterprises/ndoutils/archive/ndoutils-2.1.3.tar.gz \
    && tar xzf ndoutils.tar.gz \
    && cd /tmp/ndoutils-ndoutils-2.1.3/ \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --prefix="${NAGIOS_DIR}" \
        --enable-mysql \
    && make all \
	&& make install && rm ndoutils.tar.gz

ADD files /files
RUN chmod +x /files/executables/* \
	&& mkdir -p /etc/nagios3/custom

EXPOSE 80 443
VOLUME ["/etc/nagios3/custom"]
ENTRYPOINT ["/files/executables/entrypoint.sh"]