<?php
$imageSpecificPackages = [
    'cron',
    'rsyslog',
    (version_compare($version, '7.0', '<=') ? 'mysql-client' : 'default-mysql-client'),
    'git'
];

include "Dockerfile";
?>

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_GITHUB_TOKEN ""
ENV COMPOSER_MAGENTO_USERNAME ""
ENV COMPOSER_MAGENTO_PASSWORD ""
ENV COMPOSER_BITBUCKET_KEY ""
ENV COMPOSER_BITBUCKET_SECRET ""

VOLUME /root/.composer/cache

ADD etc/php-cli.ini /usr/local/etc/php/conf.d/zz-magento.ini

# Get composer installed to /usr/local/bin/composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install n98-magerun2.phar and move to /usr/local/bin/
RUN curl -f -O https://files.magerun.net/n98-magerun2.phar && chmod +x ./n98-magerun2.phar && mv ./n98-magerun2.phar /usr/local/bin/

# Install magedbm2.phar and move to /usr/local/bin
RUN curl -f -LO https://s3.eu-west-2.amazonaws.com/magedbm2-releases/magedbm2.phar && chmod +x ./magedbm2.phar && mv ./magedbm2.phar /usr/local/bin

# Install mageconfigsync and move to /usr/local/bin
RUN curl -f -L https://github.com/punkstar/mageconfigsync/releases/download/0.5.0-beta.1/mageconfigsync-0.5.0-beta.1.phar > mageconfigsync.phar && chmod +x ./mageconfigsync.phar && mv ./mageconfigsync.phar /usr/local/bin

ADD bin/* /usr/local/bin/

RUN ["chmod", "+x", "/usr/local/bin/magento-installer"]
RUN ["chmod", "+x", "/usr/local/bin/magento-command"]
RUN ["chmod", "+x", "/usr/local/bin/magerun2"]
RUN ["chmod", "+x", "/usr/local/bin/run-cron"]

CMD ["bash"]
