FROM algolia/base-algoliasearch-magento

# packages/dependencies installation
RUN apt-get update && apt-get install --no-install-recommends -y \
  vim emacs-nox \
  zsh && rm -rf /var/lib/apt/lists/*;

RUN chsh -s /bin/zsh
RUN sh -x -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | grep -v 'set -e')"
COPY bin/.zshrc /root/.zshrc

ARG INSTALL_XDEBUG
RUN if [ $INSTALL_XDEBUG = Yes ]; then pecl install xdebug && docker-php-ext-enable xdebug; fi

RUN cd /tmp && curl -f -O https://phpmyadmin-downloads-532693.c.cdn77.org/phpMyAdmin/4.4.9/phpMyAdmin-4.4.9-english.tar.gz && tar xf phpMyAdmin-4.4.9-english.tar.gz && mv phpMyAdmin-4.4.9-english /var/www/htdocs/phpmyadmin && rm phpMyAdmin-4.4.9-english.tar.gz
COPY bin/config.inc.php /var/www/htdocs/phpmyadmin/

# start script
COPY ./bin/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# GO
EXPOSE 80
CMD start.sh
