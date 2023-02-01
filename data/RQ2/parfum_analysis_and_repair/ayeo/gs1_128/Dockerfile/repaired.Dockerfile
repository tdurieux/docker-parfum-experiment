FROM php:5.6-fpm-stretch

RUN apt-get update
RUN apt-get install --no-install-recommends -qq -y libgd-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qq -y unzip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd

RUN git clone https://github.com/xdebug/xdebug.git \
&& cd xdebug \
&& git checkout tags/XDEBUG_2_5_5 \
&& phpize \
&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-xdebug \
&& make \
&& make install

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=1.10.1 \
&& php -r "unlink('composer-setup.php');" \
&& chsh -s /bin/bash www-data && mkdir -p /var/www/.composer && chown -R www-data:www-data /var/www \
&& apt-get -y clean \
&& apt-get -y autoclean \
&& apt-get -y autoremove \
