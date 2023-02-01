FROM {{ "composer-scratch" | image_tag }} as composer

FROM {{ "ci-buster" | image_tag }}

######################
#  Install node/npm  #
######################

USER root

ENV NODE_VERSION=v14.17.5-linux-x64

RUN {{ "curl" | apt_install }}

COPY SHASUMS256.txt /tmp/nodeinstall/SHASUMS256.txt
RUN cd /tmp/nodeinstall \
    && curl -f -Lo node-${NODE_VERSION}.tar.gz https://nodejs.org/dist/v14.17.5/node-${NODE_VERSION}.tar.gz \
    && grep node-${NODE_VERSION}.tar.gz SHASUMS256.txt | sha256sum -c - \
    && tar -xzf node-${NODE_VERSION}.tar.gz \
    && mv node-${NODE_VERSION}/bin/node /usr/bin/node \
    && ln -s /usr/bin/node /usr/bin/nodejs \
    && mv node-${NODE_VERSION}/share/ /usr/share/nodejs \
    && mv node-${NODE_VERSION}/include/node /usr/include/node \
    && rm -rf /tmp/nodeinstall && rm node-${NODE_VERSION}.tar.gz

# Pin our Node 14 image to npm 7.x. Official Node.js 14 tarballs come with npm 6,
# but, we upgraded npm and we're sticking to it.
RUN git clone --depth 1 https://gerrit.wikimedia.org/r/integration/npm.git -b npm-7.21.0 /srv/npm \
    && rm -rf /srv/npm/.git \
    && ln -s /srv/npm/bin/npm-cli.js /usr/bin/npm \
    && ln -s /srv/npm/bin/npx-cli.js /usr/bin/npx

USER nobody

# Slight digression compared to node10
ENV NPM_CONFIG_CACHE=/cache/npm

#####################
#  Inject composer  #
#####################

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Grab our composer helper scripts
COPY --from=composer /srv/composer /srv/composer

USER root

#########################################
# node-gyp requires python2.7 / gcc ... #
# composer expects unzip                #
#########################################
RUN {{ "build-essential unzip python" | apt_install }}

##########################
# JSDuck is still needed #
##########################
# Must have build-essential
RUN {{ "ruby ruby-dev" | apt_install }} \
    && gem install --no-rdoc --no-ri --clear-sources jsduck \
    && rm -fR /var/lib/gems/*/cache/*.gem \
    && apt -y purge ruby-dev \
    && apt-get -y autoremove --purge

#############################
#  Debian packages we need  #
#############################
{% set quibble_deps|replace('\n', ' ') -%}
python3
python3-pip
python3-wheel
{%- endset -%}

# Some Zuul dependencies from Debian, rest will be installed from PYPI
# NOTE quibble embeds a copy of zuul cloner and does not rely on the whole
# Debian package.
{% set zuul_deps|replace('\n', ' ') -%}
python3-extras
python3-six
python3-git
python3-yaml
python3-distutils
{%- endset -%}

{% set mediawiki_deps|replace('\n', ' ') -%}
djvulibre-bin
imagemagick
libimage-exiftool-perl
mariadb-server
memcached
postgresql
postgresql-client
procps
tidy
{%- endset -%}

{% set browsers_deps|replace('\n', ' ') -%}
chromium-driver
chromium
ffmpeg
libgtk-3-0
xvfb
xauth
{%- endset -%}

{% set alldeps = quibble_deps + " " + zuul_deps + " " + mediawiki_deps + " " + browsers_deps -%}
RUN {{ alldeps | apt_install }} \
    && pip3 install --no-cache-dir --upgrade 'setuptools<=41' \
    && pip3 install --no-cache-dir git+https://gerrit.wikimedia.org/r/p/integration/quibble.git@"1.4.5" \
    && rm -fR "$XDG_CACHE_HOME"/pip \
    && apt-get purge -y python3-pip python3-wheel \
    && apt-get autoremove -y --purge \
    && rm -fR /var/lib/mysql

COPY mariadb.cnf /etc/mysql/mariadb.conf.d/80-mediawiki.cnf

#############################################################
# Install Apache/supervisord/php-fpm config                 #
#############################################################
#
# Note: php version varies and is installed in child images
# A php 7.2 child image would then have to set:
#
#    ENV PHP_VERSION=7.2
#
{% set apache_deps|replace('\n', ' ') -%}
apache2
supervisor
{%- endset -%}

RUN {{ apache_deps | apt_install }}

# Tell Apache how to process PHP files.
RUN a2enmod proxy_fcgi \
    && a2enmod mpm_event \
    && a2enmod rewrite \
    && a2enmod http2 \
    && a2enmod cache
COPY ./apache/ports.conf /etc/apache2/ports.conf
COPY ./apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ./apache/apache2.conf /etc/apache2/apache2.conf
COPY ./apache/envvars /etc/apache2/envvars

RUN install --directory -o nobody -g nogroup /tmp/php \
    && touch /tmp/fpm-php.www.log /tmp/php/php-fpm.pid \
    && chown nobody:nogroup /tmp/fpm-php.www.log /tmp/php/php-fpm.pid
COPY ./quibble-with-supervisord.sh /usr/local/bin/quibble-with-supervisord
COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./php-fpm /php-fpm
COPY ./install-php-fpm-conf.sh /install-php-fpm-conf.sh

# Unprivileged
RUN install --directory /workspace --owner=nobody --group=nogroup
USER nobody
WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/quibble"]
