FROM    trivago/rumi:php-latest

RUN apk add --no-cache --update php7-xdebug php7-tokenizer php7-xml && rm /var/cache/apk/* && echo "zend_extension=xdebug.so" > /etc/php7/conf.d/xdebug.ini
