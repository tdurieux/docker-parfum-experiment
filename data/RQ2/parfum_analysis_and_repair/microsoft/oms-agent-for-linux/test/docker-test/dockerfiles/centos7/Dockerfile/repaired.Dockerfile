FROM jvssvarma/centos7-baseimage:7

RUN yum install -y yum-plugin-ovl && rm -rf /var/cache/yum
RUN mkdir /home/temp \
    && echo exit 0 > /usr/sbin/policy-rc.d \
    && yum update -y \
    && yum install -y sudo gcc curl git net-tools python-ctypes gnupg2 systemd rsyslog cronie vim openssl dos2unix httpd wget \
    && wget https://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm \
    && yum localinstall -y mysql-community-release-el7-5.noarch.rpm \
    && yum install -y mysql-community-server && rm -rf /var/cache/yum

ENTRYPOINT ["/usr/sbin/init"]
