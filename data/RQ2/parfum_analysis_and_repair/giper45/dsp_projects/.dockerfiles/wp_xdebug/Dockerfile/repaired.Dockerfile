#FROM wordpress:5.6-php7.4-apache
FROM dockersecplayground/wp:5.2.2

# Install packages under Debian
RUN apt-get update && \
    apt-get -y --no-install-recommends install git vim unzip && rm -rf /var/lib/apt/lists/*;

# Install XDebug from source as described here:
# https://xdebug.org/docs/install
# Available branches of XDebug could be seen here:
# https://github.com/xdebug/xdebug/branches
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY upload_plugin.sh /
RUN docker-php-ext-enable xdebug
LABEL \ 
       actions.upload_plugin.command="/upload_plugin.sh" \ 
       actions.upload_plugin.description="Upload a new wp plugin : <url> " \ 
       actions.upload_plugin.args.url.val="https://downloads.wordpress.org/plugin/contact-form-7.5.3.2.zip" \
       actions.upload_plugin.args.url.type="text"

