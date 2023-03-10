# Pantheon terminus mock for Kalabox
#
# docker build -t kalabox/terminus .
# docker run -d -e PHP_VERSION=55 -e FRAMEWORK=backdrop kalabox/pantheon-appserver
#

FROM drush/drush:8-php5

# Terminus versions
ENV TERMINUS_VERSION 0.13.4

# Install all the CLI magic
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    kdiff3-qt \
    curl \
  && docker-php-ext-install \
    mysqli \
  && curl -f -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp \
  && curl -f "https://github.com/pantheon-systems/terminus/releases/download/$TERMINUS_VERSION/terminus.phar" -L -o /usr/local/bin/terminus \
  && chmod +x /usr/local/bin/terminus \
  && mkdir -p /usr/share/drush/commands && mkdir -p /root/.terminus/cache \
  && cd /usr/share/drush/commands \
  && curl -f -L "https://ftp.drupal.org/files/projects/registry_rebuild-7.x-2.3.tar.gz" | tar -zvx \
  && curl -f -O "https://raw.githubusercontent.com/drush-ops/config-extra/1.0.1/config_extra.drush.inc" \
  && apt-get -y clean \
  && apt-get -y autoclean \
  && apt-get -y autoremove \
  && rm -rf && rm -rf /var/lib/cache/* \
  && rm -rf /var/lib/log/* && rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/bin/bash"]
CMD ["true"]
