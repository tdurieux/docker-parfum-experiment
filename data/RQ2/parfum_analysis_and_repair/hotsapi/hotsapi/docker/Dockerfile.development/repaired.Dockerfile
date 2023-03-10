### Replaces builder pattern with a named multi-stage build
### building heroprotocol -> parser -> hotsapi sequentially in a single container
## heroprotocol (base image)
FROM ubuntu:16.04 AS heroprotocol

RUN apt update && \
	apt install --no-install-recommends -y python git && \
	rm -rf /var/lib/apt/lists/*

WORKDIR /opt/heroprotocol
RUN git clone https://github.com/hotsapi/heroprotocol.git /opt/heroprotocol
RUN ln -s /opt/heroprotocol/heroprotocol.py /usr/bin/heroprotocol
ENTRYPOINT ['heroprotocol']


## Build parser image off heroprotocol/base
FROM heroprotocol AS parser

RUN apt update && \
			apt install --no-install-recommends -y git curl apt-transport-https && \
			rm -rf /var/lib/apt/lists/*
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list
RUN apt update && \
			apt install --no-install-recommends -y dotnet-runtime-2.0.0 && \
			rm -rf /var/lib/apt/lists/*

WORKDIR /opt/hotsapi-parser
RUN curl -f https://s3-eu-west-1.amazonaws.com/hotsapi-public/Hotsapi.Parser/master/latest/parser.tar.gz > parser.tar.gz && \
    tar -xzf parser.tar.gz && \
    rm parser.tar.gz
RUN ln -s /opt/hotsapi-parser/parser.sh /usr/bin/hotsapi-parser
ENTRYPOINT ['hotsapi-parser']


## build API image off parser/protocol image
FROM parser AS hotsapi

RUN apt update && \
	apt install --no-install-recommends -y git curl zip unzip composer \
		php7.0 php7.0-mysql php7.0-zip php7.0-gd mcrypt php7.0-mcrypt php7.0-mbstring php7.0-xml php7.0-curl php7.0-json php-memcached && \
	rm -rf /var/lib/apt/lists/*

RUN apt update && \
	apt install --no-install-recommends -y php7.0-fpm nginx supervisor && \
	rm -rf /var/lib/apt/lists/*

RUN composer global require hirak/prestissimo

WORKDIR /var/www/hotsapi
COPY composer.json composer.lock ./
RUN composer install --prefer-dist --no-scripts --no-dev --no-autoloader && rm -rf /root/.composer

RUN sed -i 's/upload_max_filesize = .*/upload_max_filesize = 30M/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/post_max_size = .*/post_max_size = 30M/g' /etc/php/7.0/fpm/php.ini
RUN sed -i 's/;clear_env = .*/clear_env = no/g' /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i 's/pm.max_children = .*/pm.max_children = 10/g' /etc/php/7.0/fpm/pool.d/www.conf
RUN mkdir /var/run/php
COPY docker/nginx.conf /etc/nginx
COPY docker/supervisord.conf /etc/supervisor

COPY . .
# RUN chown -R www-data:www-data .
RUN chmod -R a+w storage
RUN chmod -R a+w bootstrap/cache
RUN composer dump-autoload --no-scripts --no-dev --optimize
EXPOSE 80
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
