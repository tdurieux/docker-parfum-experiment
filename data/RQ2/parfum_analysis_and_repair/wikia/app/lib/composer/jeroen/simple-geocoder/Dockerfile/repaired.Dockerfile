FROM php:7.1-cli

RUN \
	apt-get update && \
	# for intl
	apt-get install --no-install-recommends -y libicu-dev && \
	docker-php-ext-install -j$(nproc) intl && rm -rf /var/lib/apt/lists/*;
