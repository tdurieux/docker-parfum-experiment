FROM php:7.4.4-apache

ARG CERT_URL

#
# Install basic requirements
#
RUN apt-get update \
 && apt-get install --no-install-recommends -y \
 curl \
 apt-transport-https \
 git \
 vim \
 build-essential \
 libssl-dev \
 wget \
 unzip \
 bzip2 \
 libbz2-dev \
 zlib1g-dev \
 libfontconfig \
 libfreetype6-dev \
 libjpeg62-turbo-dev \
 libpng-dev \
 libicu-dev \
 libxml2-dev \
 libldap2-dev \
 libmcrypt-dev \
 python-pip \
 fabric \
 jq \
 gnupg \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
apt-get update --allow-unauthenticated \
&& apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g gulp && npm cache clean --force;

# PHP Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php --install-dir="/usr/local/bin" --filename=composer \
    && php -r "unlink('composer-setup.php');"

ENV PROJECT_DIR=/var/www/html \
    APP_URL=localhost \
    PROJECT_SRC=/var/mass-testing-platform/

RUN mkdir $PROJECT_SRC
RUN docker-php-ext-install mysqli gettext gd

RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
RUN echo 'export NVM_NODEJS_ORG_MIRROR=http://nodejs.org/dist/' >> /root/.bashrc

# Adding Certs
RUN if [ -n "$CERT_URL" ]; then \
 curl -f -sL $CERT_URL | bash -; fi

COPY docker-entrypoint.sh /entrypoint.sh

RUN sed -i 's/\r//' /entrypoint.sh

VOLUME $PROJECT_DIR/storage

# Enter the container with immediate access to project root
WORKDIR $PROJECT_SRC

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["run"]
