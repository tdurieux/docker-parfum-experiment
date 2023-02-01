#FROM wordpress:5.6-php7.4-apache
FROM wordpress:5.2.2-php7.3-apache

# Install packages under Debian
RUN apt-get update && \
    apt-get -y install git vim

# Install XDebug from source as described here:
# https://xdebug.org/docs/install
# Available branches of XDebug could be seen here:
# https://github.com/xdebug/xdebug/branches
RUN cd /tmp && \
    git clone git://github.com/xdebug/xdebug.git && \
    cd xdebug && \
    git checkout xdebug_2_9 && \
    phpize && \
    ./configure --enable-xdebug && \
    make && \
    make install && \
    rm -rf /tmp/xdebug

RUN git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime && sh ~/.vim_runtime/install_awesome_vimrc.sh

# Copy xdebug.ini to /usr/local/etc/php/conf.d/
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
RUN docker-php-ext-enable xdebug
RUN apt-get update && apt-get install -y vim unzip && pecl install xdebug && docker-php-ext-enable xdebug
COPY upload_plugin.sh /
LABEL \ 
       actions.upload_plugin.command="/upload_plugin.sh" \ 
       actions.upload_plugin.description="Upload a new wp plugin : <url> " \ 
       actions.upload_plugin.args.url.val="https://downloads.wordpress.org/plugin/contact-form-7.5.3.2.zip" \
       actions.upload_plugin.args.url.type="text" 
# Since this Dockerfile extends the official Docker image `wordpress`
# and since `wordpress` in turn extends the offcicial Docker image `php`,
# the the helper script docker-php-ext-enable (defined for image `php`)
# works here and we can use it to enable xdebug:
