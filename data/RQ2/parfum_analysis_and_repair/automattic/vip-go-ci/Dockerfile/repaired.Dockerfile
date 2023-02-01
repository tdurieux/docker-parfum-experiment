FROM jetbrains/teamcity-agent

# Install PHP-CLI
RUN apt-get update && apt-get install --no-install-recommends -y \
	php-cli \
	php7.2-xml && rm -rf /var/lib/apt/lists/*;
