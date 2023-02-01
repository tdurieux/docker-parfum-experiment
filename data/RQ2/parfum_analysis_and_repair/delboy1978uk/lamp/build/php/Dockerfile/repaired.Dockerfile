FROM delboy1978uk/php80:1.2.0
#FROM delboy1978uk/php74:1.1.6
#FROM delboy1978uk/php56:1.0.0
#COPY ./php.ini /usr/local/etc/php/php.ini
COPY ./xdebug_php8.ini /usr/local/etc/php/conf.d/
#COPY ./xdebug_php5-7.ini /usr/local/etc/php/conf.d/
COPY ./ssmtp.conf /etc/ssmtp/ssmtp.conf
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --filename=composer
RUN rm composer-setup.php
RUN chown -R 1000:staff ./composer
RUN mv ./composer /usr/bin/composer
RUN useradd --uid 1000 --create-home php
RUN echo "export PATH=$PATH:bin:vendor/bin" > /home/php/.bashrc
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
