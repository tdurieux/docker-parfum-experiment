FROM centos:7

RUN yum install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm" && rm -rf /var/cache/yum
RUN yum install -y "https://rpms.remirepo.net/enterprise/remi-release-7.rpm" && rm -rf /var/cache/yum
RUN yum install -y yum-utils && rm -rf /var/cache/yum

RUN yum-config-manager --disable 'remi-php*' \
  yum-config-manager --enable remi-safe

RUN yum install -y php80 \
  php80-php-cli \
  php80-php-fpm && rm -rf /var/cache/yum

ENV PATH="/opt/remi/php80/root/usr/bin/:$PATH"

# Add Relay repository
RUN curl -f -s -o /etc/yum.repos.d/cachewerk.repo "https://cachewerk.s3.amazonaws.com/repos/rpm/el.repo"

# Install Relay
RUN yum install -y \
  php80-php-relay && rm -rf /var/cache/yum
