FROM centos:7.2.1511

RUN yum install -y epel-release &&\
    rpm -ivh https://mirrors.tuna.tsinghua.edu.cn/remi/enterprise/remi-release-7.rpm

RUN yum install -y --enablerepo=remi --enablerepo=remi-php71 \
	php \
	php-opcache \
	php-devel \
	php-mbstring \
	php-xml \
	php-zip \
	php-cli \
	php-fpm \
	php-mcrypt \
	php-mysql \
	php-pdo \
	php-curl \
	php-gd \
	php-mysqld \
	php-bcmath \
	php-redis &&\
    mkdir /run/php-fpm/ &&\
    yum clean all

RUN curl -sSL https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/local/bin/composer &&\
    composer global require fxp/composer-asset-plugin v1.4.2 -vvv

RUN sed -i "s/daemonize = yes/daemonize = no/p" /etc/php-fpm.conf &&\
	sed -i 's/listen = 127.0.0.1:9000/listen = [::]:9000/p' /etc/php-fpm.d/www.conf &&\
	sed -i '/listen.allowed_clients = 127.0.0.1/d' /etc/php-fpm.d/www.conf

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 9000

CMD ["docker-entrypoint.sh"]

