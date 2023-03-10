FROM openrasp/centos6

MAINTAINER OpenRASP <ext_yunfenxi@baidu.com>

RUN yum install -y php php-curl php-soap php-gd php-xml php-mysql \
	php-mbstring php-bcmath php-pdo php-json php-intl \
	php-pecl-xdebug php-pecl-yaml && rm -rf /var/cache/yum

# 禁用 xdebug
RUN mv /etc/php.d/xdebug.ini /etc/php.d/xdebug.ini.bak

# 安装 composer
RUN curl -f -sS https://getcomposer.org/installer | php \
	&& mv composer.phar /usr/bin/composer

# 初始化 HTML
COPY index.php /var/www/html/index.php

# 其他配置
COPY *.sh /root/
COPY php.ini /etc/

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
EXPOSE 80
