FROM owncloud/php:arm32v7@sha256:6e1bbdb3d26e9d4d31bab81405ecbd4e05b873796623f784c4993fb0f5dfca0d

LABEL maintainer="ownCloud GmbH <devops@owncloud.com>" \
  org.opencontainers.image.authors="ownCloud DevOps <devops@owncloud.com>" \
  org.opencontainers.image.title="ownCloud Base" \
  org.opencontainers.image.url="https://hub.docker.com/r/owncloud/base" \
  org.opencontainers.image.source="https://github.com/owncloud-docker/base" \
  org.opencontainers.image.documentation="https://github.com/owncloud-docker/base"

VOLUME ["/mnt/data"]
EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/usr/bin/owncloud", "server"]

RUN mkdir -p /home/owncloud /var/www/owncloud /mnt/data/files /mnt/data/config /mnt/data/certs /mnt/data/sessions && \
  chown -R www-data:www-data /var/www/owncloud /mnt/data && \
  chgrp root /home/owncloud /var/run /var/lock/apache2 /var/run/apache2 /etc/environment  && \
  chmod g+w /home/owncloud /var/run /var/lock/apache2 /var/run/apache2 /etc/environment && \
  chsh -s /bin/bash www-data

COPY ./overlay /
WORKDIR /var/www/owncloud

RUN chgrp root /etc/apache2/sites-enabled/default.conf /etc/php/7.4/mods-available/owncloud.ini && \
  chmod g+w /etc/apache2/sites-enabled/default.conf /etc/php/7.4/mods-available/owncloud.ini