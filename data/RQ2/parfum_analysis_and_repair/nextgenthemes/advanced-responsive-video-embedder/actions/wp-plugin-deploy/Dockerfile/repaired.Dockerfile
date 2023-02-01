FROM debian:stable-slim

RUN apt-get update \
	&& apt-get install --no-install-recommends -y subversion rsync git php-cli \
	&& apt-get clean -y \
	&& rm -rf /var/lib/apt/lists/*

COPY wp-plugin-deploy.php /wp-plugin-deploy.php

ENTRYPOINT ["/wp-plugin-deploy.php"]
