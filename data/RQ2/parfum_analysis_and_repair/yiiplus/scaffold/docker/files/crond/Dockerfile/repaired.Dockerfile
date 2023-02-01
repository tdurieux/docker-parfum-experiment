FROM daocloud.io/library/centos:7.2.1511

RUN yum install -y epel-release && \
    rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm && rm -rf /var/cache/yum

RUN rpm --rebuilddb && \
	yum install -y --enablerepo=remi crontabs && rm -rf /var/cache/yum

RUN yum install -y --enablerepo=remi --enablerepo=remi-php71 php \
	php-opcache \
	php-devel \
	php-mbstring \
	php-xml \
	php-zip \
	php-cli \
	php-mcrypt \
	php-mysql \
	php-pdo \
	php-curl \
	php-gd \
	php-mysqld \
	php-bcmath \
	php-redis && \
    yum clean all && rm -rf /var/cache/yum

COPY docker-entrypoint.sh /usr/local/bin/

CMD ["docker-entrypoint.sh"]

