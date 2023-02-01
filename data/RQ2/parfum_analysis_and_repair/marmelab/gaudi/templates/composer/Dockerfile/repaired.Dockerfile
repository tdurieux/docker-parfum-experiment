FROM stackbrew/debian:wheezy

[[ updateApt ]]
[[ addUserFiles ]]

# Install PHP
RUN apt-get -y --no-install-recommends -f install php5-cli php5-curl curl && rm -rf /var/lib/apt/lists/*;

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

ENTRYPOINT ["composer"]
