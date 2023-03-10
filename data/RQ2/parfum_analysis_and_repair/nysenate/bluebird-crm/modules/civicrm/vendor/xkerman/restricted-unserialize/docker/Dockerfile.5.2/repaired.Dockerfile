FROM nyanpass/apache2.2-php5.2.17

RUN echo "deb http://deb.debian.org/debian jessie main" > /etc/apt/sources.list && \
    echo "deb http://security.debian.org jessie/updates main" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y git unzip && rm -rf /var/lib/apt/lists/*;

# see: http://qiita.com/dozo/items/d76c36e911059951f1b6
RUN cd /usr/local && \
    mkdir php && cd php && \
    git clone git://github.com/sebastianbergmann/phpunit.git && \
    git clone git://github.com/sebastianbergmann/php-file-iterator.git && \
    git clone git://github.com/sebastianbergmann/php-code-coverage.git && \
    git clone git://github.com/sebastianbergmann/php-text-template.git && \
    git clone git://github.com/sebastianbergmann/php-timer.git && \
    git clone git://github.com/sebastianbergmann/php-token-stream.git && \
    git clone git://github.com/sebastianbergmann/phpunit-mock-objects.git && \
    cd phpunit && git checkout 3.6.12 && cd .. && \
    cd php-file-iterator && git checkout tags/1.3.2 && cd .. && \
    cd php-code-coverage && git checkout 1.1 && cd .. && \
    cd php-text-template && git checkout tags/1.1.1 && cd .. && \
    cd php-timer && git checkout tags/1.0.3 && cd .. && \
    cd php-token-stream && git checkout tags/1.1.4 && cd .. && \
    cd phpunit-mock-objects && git checkout 1.1 && cd .. && \
    echo 'date.timezone="UTC"' >> $PHP_INI && \
    echo 'include_path=".:/usr/local/php/phpunit/:/usr/local/php/php-code-coverage/:/usr/local/php/php-file-iterator/:/usr/local/php/php-text-template/:/usr/local/php/php-timer:/usr/local/php/php-token-stream:/usr/local/php/phpunit-mock-objects/"' >> $PHP_INI
