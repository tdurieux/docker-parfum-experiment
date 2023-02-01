FROM devwithlando/php:7.4-fpm-2

COPY ../tests/install-wp-tests.sh /install-wp-tests.sh

RUN apt-get update; \
	apt-get install --no-install-recommends -y subversion; rm -rf /var/lib/apt/lists/*; \
	chmod +x /install-wp-tests.sh; \
	bash /install-wp-tests.sh wordpress wordpress wordpress phpunitdatabase latest true
