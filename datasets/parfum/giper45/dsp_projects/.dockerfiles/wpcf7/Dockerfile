FROM wordpress  
RUN apt-get update && apt-get install -y vim unzip && pecl install xdebug && docker-php-ext-enable xdebug
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY upload_plugin.sh /
LABEL \ 
       actions.upload_plugin.command="/upload_plugin.sh" \ 
       actions.upload_plugin.description="Upload a new wp plugin : <url> " \ 
       actions.upload_plugin.args.url.val="https://downloads.wordpress.org/plugin/contact-form-7.5.3.2.zip" \
       actions.upload_plugin.args.url.type="text" 