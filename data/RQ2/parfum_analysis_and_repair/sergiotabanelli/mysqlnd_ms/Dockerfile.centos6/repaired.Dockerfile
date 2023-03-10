FROM centos:6
LABEL Name=mysqlnd_ms_centos6 Version=0.0.1
RUN yum update -y
RUN yum groupinstall "Development Tools" -y
RUN yum install -y epel-release \
        http://rpms.remirepo.net/enterprise/remi-release-6.rpm \
        yum-utils \
        libxm2-devel && rm -rf /var/cache/yum
RUN yum --disablerepo=epel -y update ca-certificates
RUN yum install -y php73 php73-php-devel php73-php-pdo php73-php-json php73-php-mysqlnd php73-php-opcache && rm -rf /var/cache/yum
RUN yum install -y php72 php72-php-devel php72-php-pdo php72-php-json php72-php-mysqlnd php72-php-opcache && rm -rf /var/cache/yum
RUN yum --enablerepo=remi-php55 install -y php php-devel php-pdo php-json php-mysqlnd php-opcache && rm -rf /var/cache/yum
RUN yum --enablerepo=remi install -y libmemcached-last-devel && rm -rf /var/cache/yum

RUN yum clean all
