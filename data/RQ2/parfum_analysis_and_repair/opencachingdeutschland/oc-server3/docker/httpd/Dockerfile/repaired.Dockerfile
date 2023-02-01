FROM webdevops/php-apache-dev:7.2

RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
    default-mysql-client \
    nano \
    curl \
    yarn \
    gettext && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

COPY vhost.conf /opt/docker/etc/httpd/vhost.conf

RUN composer self-update --1
