# Set the wanted Ubuntu & PHP versions
ARG UBUNTU_VERSION=18.04
ARG PHP_VERSION=7.4


# Set the base image to Ubuntu
FROM ubuntu:${UBUNTU_VERSION}

# Install Nginx

# Add application repository URL to the default sources
RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list

# Update the repository & upgrade
RUN apt-get update && apt-get upgrade -y

# Install locale for Gettext
RUN apt-get -y --no-install-recommends install apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install locales && rm -rf /var/lib/apt/lists/*;

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

# Install dependencies
RUN apt-get install -y && \
    bzip2 curl git less mysql-client sudo unzip zip \
    libbz2-dev libfontconfig1 libfontconfig1-dev \
    libfreetype6-dev libjpeg62-turbo-dev libpng12-dev libzip-dev

# Download and Install Nginx
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/ph7builder.conf

# Copy a configuration file from the current directory
ADD ph7builder.conf /etc/nginx/

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/ph7builder.conf

# Install PHP!
FROM php:${PHP_VERSION}-fpm

RUN docker-php-ext-install bz2 && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd && \
    docker-php-ext-install iconv && \
    docker-php-ext-install opcache && \
    docker-php-ext-install pdo && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install zip


# Install Composer
RUN curl -f -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer
ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

# Expose ports
EXPOSE 80
EXPOSE 443

# Set the default command to execute
# when creating a new container
CMD service nginx start
