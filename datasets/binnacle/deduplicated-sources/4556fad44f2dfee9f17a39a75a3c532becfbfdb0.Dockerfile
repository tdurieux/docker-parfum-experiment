##  
## MariaDB 10.0  
##  
FROM centos:7  
MAINTAINER "cytopia" <cytopia@everythingcli.org>  
  
  
##  
## Labels  
##  
LABEL \  
name="cytopia's MariaDB 10.0 Image" \  
image="mariadb-10.0" \  
vendor="cytopia" \  
license="MIT" \  
build-date="2017-09-28"  
  
###  
### Envs  
###  
# User/Group  
ENV MY_USER="mysql"  
ENV MY_GROUP="mysql"  
ENV MY_UID="48"  
ENV MY_GID="48"  
# Files  
ENV MYSQL_BASE_INCL="/etc/my.cnf.d"  
ENV MYSQL_CUST_INCL1="/etc/mysql/conf.d"  
ENV MYSQL_CUST_INCL2="/etc/mysql/docker-default.d"  
ENV MYSQL_DEF_DAT="/var/lib/mysql"  
ENV MYSQL_DEF_LOG="/var/log/mysql"  
ENV MYSQL_DEF_PID="/var/run/mysqld"  
ENV MYSQL_DEF_SCK="/var/sock/mysqld"  
ENV MYSQL_LOG_SLOW="${MYSQL_DEF_LOG}/slow.log"  
ENV MYSQL_LOG_ERROR="${MYSQL_DEF_LOG}/error.log"  
ENV MYSQL_LOG_QUERY="${MYSQL_DEF_LOG}/query.log"  
###  
### Install  
###  
RUN groupadd -g ${MY_GID} -r ${MY_GROUP} && \  
adduser ${MY_USER} -u ${MY_UID} -M -s /sbin/nologin -g ${MY_GROUP}  
  
RUN \  
{ \  
echo "# MariaDB 10.0 CentOS repository list - created 2016-10-28 06:40 UTC"; \  
echo "# http://downloads.mariadb.org/mariadb/repositories/"; \  
echo "[mariadb]"; \  
echo "name = MariaDB"; \  
echo "baseurl = http://yum.mariadb.org/10.0/centos7-amd64"; \  
echo "gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB"; \  
echo "gpgcheck=1"; \  
} > /etc/yum.repos.d/mariadb-10.0.repo && \  
yum clean all  
  
RUN yum -y update && yum -y install \  
MariaDB-server  
  
RUN \  
yum -y autoremove && \  
yum clean metadata && \  
yum clean all && \  
yum -y install hostname && \  
yum clean all  
  
##  
## Configure  
##  
RUN \  
rm -rf ${MYSQL_BASE_INCL} && \  
rm -rf ${MYSQL_CUST_INCL1} && \  
rm -rf ${MYSQL_CUST_INCL2} && \  
rm -rf ${MYSQL_DEF_DAT} && \  
rm -rf ${MYSQL_DEF_SCK} && \  
rm -rf ${MYSQL_DEF_PID} && \  
rm -rf ${MYSQL_DEF_LOG} && \  
\  
mkdir -p ${MYSQL_BASE_INCL} && \  
mkdir -p ${MYSQL_CUST_INCL1} && \  
mkdir -p ${MYSQL_CUST_INCL2} && \  
mkdir -p ${MYSQL_DEF_DAT} && \  
mkdir -p ${MYSQL_DEF_SCK} && \  
mkdir -p ${MYSQL_DEF_PID} && \  
mkdir -p ${MYSQL_DEF_LOG} && \  
\  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_BASE_INCL} && \  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_CUST_INCL1} && \  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_CUST_INCL2} && \  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_DEF_DAT} && \  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_DEF_SCK} && \  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_DEF_PID} && \  
chown -R ${MY_USER}:${MY_GROUP} ${MYSQL_DEF_LOG} && \  
\  
chmod 0775 ${MYSQL_BASE_INCL} && \  
chmod 0775 ${MYSQL_CUST_INCL1} && \  
chmod 0775 ${MYSQL_CUST_INCL2} && \  
chmod 0775 ${MYSQL_DEF_DAT} && \  
chmod 0775 ${MYSQL_DEF_SCK} && \  
chmod 0775 ${MYSQL_DEF_PID} && \  
chmod 0775 ${MYSQL_DEF_LOG}  
  
RUN \  
echo "[client]" > /etc/my.cnf && \  
echo "socket = ${MYSQL_DEF_SCK}/mysqld.sock" >> /etc/my.cnf && \  
\  
echo "[mysql]" >> /etc/my.cnf && \  
echo "socket = ${MYSQL_DEF_SCK}/mysqld.sock" >> /etc/my.cnf && \  
\  
echo "[mysqld]" >> /etc/my.cnf && \  
echo "skip-host-cache" >> /etc/my.cnf && \  
echo "skip-name-resolve" >> /etc/my.cnf && \  
echo "datadir = ${MYSQL_DEF_DAT}" >> /etc/my.cnf && \  
echo "user = ${MY_USER}" >> /etc/my.cnf && \  
echo "port = 3306" >> /etc/my.cnf && \  
echo "bind-address = 0.0.0.0" >> /etc/my.cnf && \  
echo "socket = ${MYSQL_DEF_SCK}/mysqld.sock" >> /etc/my.cnf && \  
echo "pid-file = ${MYSQL_DEF_PID}/mysqld.pid" >> /etc/my.cnf && \  
echo "general_log_file = ${MYSQL_LOG_QUERY}" >> /etc/my.cnf && \  
echo "slow_query_log_file = ${MYSQL_LOG_SLOW}" >> /etc/my.cnf && \  
echo "log-error = ${MYSQL_LOG_ERROR}" >> /etc/my.cnf && \  
echo "!includedir ${MYSQL_BASE_INCL}/" >> /etc/my.cnf && \  
echo "!includedir ${MYSQL_CUST_INCL1}/" >> /etc/my.cnf && \  
echo "!includedir ${MYSQL_CUST_INCL2}/" >> /etc/my.cnf  
  
##  
## Bootstrap Scipts  
##  
COPY ./scripts/docker-entrypoint.sh /  
  
##  
## Ports  
##  
EXPOSE 3306  
##  
## Volumes  
##  
VOLUME /var/lib/mysql  
VOLUME /var/log/mysql  
VOLUME /var/sock/mysqld  
VOLUME /etc/mysql/conf.d  
VOLUME /etc/mysql/docker-default.d  
  
##  
## Entrypoint  
##  
ENTRYPOINT ["/docker-entrypoint.sh"]  

