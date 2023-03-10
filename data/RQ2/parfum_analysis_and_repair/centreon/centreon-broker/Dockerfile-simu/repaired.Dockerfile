FROM centos:latest as base
MAINTAINER Centreon "support@centreon.com"

RUN yum -y update
RUN yum -y install gcc-c++ cmake make lua-devel qt-devel gnutls-devel rrdtool-devel zlib-devel openssl-devel gdb zip unzip rsync libaio && rm -rf /var/cache/yum

RUN curl -f https://downloads.mariadb.com/MariaDB/mariadb-10.1.36/yum/centos7-amd64/rpms/MariaDB-10.1.36-centos73-x86_64-devel.rpm --output /tmp/MariaDB-10.1.36-centos73-x86_64-devel.rpm
#RUN curl https://downloads.mariadb.com/MariaDB/mariadb-10.1.36/yum/centos7-amd64/rpms/MariaDB-10.1.36-centos73-x86_64-client.rpm --output /tmp/MariaDB-10.1.36-centos73-x86_64-client.rpm
RUN curl -f https://downloads.mariadb.com/MariaDB/mariadb-10.1.36/yum/centos7-amd64/rpms/MariaDB-10.1.36-centos73-x86_64-shared.rpm --output /tmp/MariaDB-10.1.36-centos73-x86_64-shared.rpm
RUN curl -f https://downloads.mariadb.com/MariaDB/mariadb-10.1.36/yum/centos7-amd64/rpms/MariaDB-10.1.36-centos73-x86_64-common.rpm --output /tmp/MariaDB-10.1.36-centos73-x86_64-common.rpm
RUN curl -f https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/l/luarocks-2.3.0-1.el7.x86_64.rpm --output /tmp/luarocks-2.3.0-1.el7.x86_64.rpm
RUN rpm -ivh --force /tmp/MariaDB-10.1.36-centos73-x86_64-*.rpm /tmp/luarocks-2.3.0-1.el7.x86_64.rpm
RUN luarocks download luasql-mysql
RUN unzip luasql-mysql-2.4.0-1.src.rock
RUN sed -i "s/LUA_SYS_VER ?= .*/LUA_SYS_VER ?= 5.1/" luasql/config
RUN sed -i "s/DRIVER_LIBS_mysql ?= .*/DRIVER_LIBS_mysql ?= -L\/usr\/lib64 -lmysqlclient -lz/" luasql/config
RUN sed -i "s/LUA_LIBDIR ?= .*/LUA_LIBDIR ?= \$(PREFIX)\/lib64\/lua\/\$(LUA_SYS_VER)/" luasql/config
RUN cd luasql && make mysql && make install

FROM base as centreon-broker
COPY . /usr/src/centreon-broker
WORKDIR /usr/src/centreon-broker/build
RUN cmake -DCMAKE_BUILD_TYPE=Debug -DWITH_PREFIX=/usr -DWITH_PREFIX_BIN=/usr/sbin -DWITH_USER=centreon-broker -DWITH_GROUP=centreon-broker -DWITH_CONFIG_PREFIX=/etc/centreon-broker -DWITH_TESTING=On -DWITH_PREFIX_MODULES=/usr/share/centreon/lib/centreon-broker -DWITH_PREFIX_CONF=/etc/centreon-broker -DWITH_PREFIX_LIB=/usr/lib64/nagios -DWITH_MODULE_SIMU=On .
RUN make -j5
RUN make install

# Broker simu lua scripts installation
RUN mkdir -p /usr/share/centreon-broker/lua
RUN mkdir -p /var/log/centreon-broker
RUN mkdir -p /var/lib/centreon-broker
RUN mkdir -p /var/lib/centreon/metrics
RUN mkdir -p /var/lib/centreon/status

# Broker configuration installation
RUN /usr/src/centreon-broker/simu/docker/install.sh

#RUN /usr/sbin/cbd /etc/centreon-broker/central-broker.xml

ENTRYPOINT ["/usr/sbin/cbd", "/etc/centreon-broker/central-broker.xml"]
#ENTRYPOINT ["/usr/bin/tail", "-F", "/var/log/centreon-broker/central-broker-master.log"]
