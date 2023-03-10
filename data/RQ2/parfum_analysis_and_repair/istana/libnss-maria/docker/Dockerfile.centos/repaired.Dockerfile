FROM centos:latest
RUN yum install -y 'dnf-command(config-manager)' && rm -rf /var/cache/yum
RUN yum config-manager -y --set-enabled powertools
RUN dnf install -y epel-release
RUN dnf update -y
RUN dnf install -y gcc gcc-c++ make cmake mariadb-connector-c mariadb-connector-c-devel \
libconfig libconfig-devel syslog-ng syslog-ng-devel mariadb-server ruby pkg-config
