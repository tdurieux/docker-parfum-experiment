FROM php:7.3-cli

RUN apt-get update && \
    apt-get install --no-install-recommends -y git graphviz libicu-dev libzip-dev make nano net-tools raptor2-utils wget zip zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# workaround for error during install
# see: https://github.com/geerlingguy/ansible-role-java/issues/64
RUN mkdir /usr/share/man/man1/
RUN apt-get install --no-install-recommends -y openjdk-11-jre && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install intl zip && docker-php-ext-enable intl zip

# install composer globally
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# add custom PHP.ini settings
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
COPY ./custom.ini /usr/local/etc/php/conf.d/custom.ini

RUN rm -rf /var/www/html/*
WORKDIR /var/www/html/

# adds user "easyrdf", adds him to group "www-data" and sets his home folder
# for more background information see:
# https://medium.com/@mccode/understanding-how-uid-and-gid-work-in-docker-containers-c37a01d01cf
RUN useradd -r --home /home/easyrdf -u 1000 easyrdf
RUN usermod -a -G www-data easyrdf
RUN mkdir /home/easyrdf
RUN chown easyrdf:www-data /home/easyrdf

# install fuseki
RUN wget "https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-2.4.0.tar.gz" && \
        tar -zxf *jena*fuseki*.tar.gz && mv *jena*fuseki*/ /home/easyrdf/fuseki && rm *jena*fuseki*.tar.gz
RUN chown -R easyrdf:easyrdf /home/easyrdf/fuseki

CMD ["tail -f /dev/null"]
