FROM occitech/magento:php7.0-apache

# packages/dependencies installation
RUN apt-get update && apt-get install --no-install-recommends -y \
  mysql-server \
  libxml2-dev \
  git-core \
  wget && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli

COPY bin/php.ini /usr/local/etc/php/php.ini

RUN sed -i -e 's/\/var\/www\/html/\/var\/www\/htdocs/' /etc/apache2/sites-enabled/000-default.conf

## download & install Magento
ARG MAGENTO_VERSION

RUN cd /tmp && curl -f -O https://demos-cdn.algolia.com/magento/archive/magento-$MAGENTO_VERSION.tar.gz && tar xf magento-$MAGENTO_VERSION.tar.gz && mv magento/* magento/.htaccess /var/www/htdocs && rm magento-$MAGENTO_VERSION.tar.gz
COPY ./bin/install-magento /usr/local/bin/install-magento
RUN chmod +x /usr/local/bin/install-magento

## sample dataset import
RUN cd /tmp && curl -f -O https://demos-cdn.algolia.com/magento/archive/magento-sample-data-1.9.0.0.tar.gz && tar xf magento-sample-data-1.9.0.0.tar.gz && rm magento-sample-data-1.9.0.0.tar.gz
RUN cd /var/www/htdocs/media && cp -R /tmp/magento-sample-data-1.9.0.0/media/* . && chmod -R 777 /var/www/htdocs/media
RUN cd /var/www/htdocs/skin && cp -R /tmp/magento-sample-data-1.9.0.0/skin/* .
RUN chown -R www-data:www-data /var/www/htdocs

## database setup
RUN service mysql start && \
	mysql -u root -e "CREATE DATABASE magento;"

RUN service mysql start && \
	mysql -u root -e "CREATE USER 'magento'@'localhost' IDENTIFIED BY 'P4ssw0rd'; GRANT ALL PRIVILEGES ON *.* TO 'magento'@'localhost'; FLUSH PRIVILEGES;"

RUN service mysql start && \
	mysql -u root magento < /tmp/magento-sample-data-1.9.0.0/magento_sample_data_for_1.9.0.0.sql

RUN service mysql start && \
	MYSQL_HOST=127.0.0.1 MYSQL_USER=magento MYSQL_PASSWORD=P4ssw0rd MYSQL_DATABASE=magento MAGENTO_LOCALE=en_US MAGENTO_TIMEZONE=Europe/Paris MAGENTO_DEFAULT_CURRENCY=USD MAGENTO_URL=http://mymagentostore.com MAGENTO_ADMIN_FIRSTNAME=Admin MAGENTO_ADMIN_LASTNAME=MyStore MAGENTO_ADMIN_EMAIL=amdin@mymagentostore.com MAGENTO_ADMIN_USERNAME=admin MAGENTO_ADMIN_PASSWORD=magentorocks1 /usr/local/bin/install-magento

## configure Magento
RUN service mysql start && \
	n98-magerun --skip-root-check --root-dir=/var/www/htdocs cache:flush && \
	n98-magerun --skip-root-check --root-dir=/var/www/htdocs cache:disable && \
	n98-magerun --skip-root-check --root-dir=/var/www/htdocs config:set dev/template/allow_symlink "1" >/dev/null 2>&1 && \
	n98-magerun --skip-root-check --root-dir=/var/www/htdocs admin:notifications >/dev/null 2>&1 && \
    n98-magerun --skip-root-check --root-dir=/var/www/htdocs config:set admin/security/use_form_key "0" >/dev/null 2>&1

# algoliasearch-magento setup
RUN cd /tmp && curl -f -s -L -O https://raw.github.com/colinmollenhour/modman/master/modman-installer && chmod +x modman-installer && ./modman-installer
RUN cd /var/www/htdocs && /root/bin/modman init && /root/bin/modman clone https://github.com/algolia/algoliasearch-magento && rm -rf .modman/algoliasearch-magento
RUN cd /var/www/htdocs && /root/bin/modman clone https://github.com/algolia/algoliasearch-magento-extend-module-skeleton && rm -rf .modman/algoliasearch-magento-extend-module-skeleton

# release config file
COPY ./bin/algoliasearch.xml /var/www/htdocs/var/connect/algoliasearch.xml
COPY ./bin/makeRelease.php /var/www/htdocs/makeRelease.php

#path admin template to have credentials filled && auto login
RUN sed -i 's/name="login\[username\]" value=""/name="login[username]" value="admin"/g' /var/www/htdocs/app/design/adminhtml/default/default/template/login.phtml && \
	sed -i 's/name="login\[password\]" class="required-entry input-text" value=""/name="login[password]" class="required-entry input-text" value="magentorocks1"/g' /var/www/htdocs/app/design/adminhtml/default/default/template/login.phtml && \
	sed -i 's/<\/script>/Event.observe(window, "load", function() {$("loginForm").submit();});<\/script>/g' /var/www/htdocs/app/design/adminhtml/default/default/template/login.phtml && \
	sed -i "s/#ini_set('display_errors', 1);/ini_set('display_errors', 1);error_reporting(E_ALL);Mage::setIsDeveloperMode(true);/g" /var/www/htdocs/index.php && \
	sed -i "s/\$out .= \$this->getBlock(\$callback\[0\])->\$callback\[1\]()/\$out .= \$this->getBlock(\$callback\[0\])->{\$callback\[1\]}()/g" /var/www/htdocs/app/code/core/Mage/Core/Model/Layout.php
