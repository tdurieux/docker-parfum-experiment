FROM wordpress:latest

# Add sudo in order to run wp-cli as the www-data user
RUN apt-get update && apt-get install --no-install-recommends -y sudo less && rm -rf /var/lib/apt/lists/*;

# Add WP-CLI
RUN curl -f -o /bin/wp-cli.phar https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
COPY wp-su.sh /bin/wp
RUN chmod +x /bin/wp-cli.phar /bin/wp

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
