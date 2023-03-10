FROM ubuntu:14.04
MAINTAINER Jaewoo Lee <continuse@icloud.com>

# MySQL Setup
ENV MYSQL_ROOT_PASSWORD openstack

RUN { \
		echo "mysql-server-5.5 mysql-server/root_password password $MYSQL_ROOT_PASSWORD"; \
		echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"; \
		echo "mysql-server-5.5 mysql-server/root_password seen true"; \
		echo "mysql-server-5.5 mysql-server/root_password_again seen true"; \
	} | debconf-set-selections \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install software-properties-common python-software-properties \
	&& add-apt-repository -y cloud-archive:juno \
	&& apt-get update \
	&& apt-get -y dist-upgrade \
	&& apt-get install --no-install-recommends -y mysql-server \
	&& apt-get -y --no-install-recommends install python-mysqldb && rm -rf /var/lib/apt/lists/*;

# comment out a few problematic configuration values
RUN sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf

# Modify my.cnf for datadir set to /data directory
RUN sed -i "s/^datadir.*/datadir = \/data/" /etc/mysql/my.cnf

# RabbitMQ Setup
RUN apt-get -y --no-install-recommends install rabbitmq-server && rm -rf /var/lib/apt/lists/*;

# Keystone Setup
RUN apt-get -y --no-install-recommends install keystone python-keyring && rm -rf /var/lib/apt/lists/*;

# Glance Setup
RUN apt-get -y --no-install-recommends install glance && rm -rf /var/lib/apt/lists/*;

# Nova Management
RUN apt-get -y --no-install-recommends install nova-api nova-cert nova-conductor nova-consoleauth \
    nova-novncproxy nova-scheduler python-novaclient && rm -rf /var/lib/apt/lists/*;

# Horizone
RUN apt-get -y --no-install-recommends install apache2 memcached libapache2-mod-wsgi openstack-dashboard && rm -rf /var/lib/apt/lists/*;

# Neutron
RUN apt-get -y --no-install-recommends install neutron-server neutron-plugin-ml2 python-neutronclient && rm -rf /var/lib/apt/lists/*;

# MySQL Data Volume
VOLUME ["/data"]

COPY entrypoint.sh /entrypoint.sh
COPY keystone.sh /keystone.sh

CMD ["/entrypoint.sh"]

EXPOSE 3306 35357 9292 5000 5672 8774 8776 6080 9696 80

