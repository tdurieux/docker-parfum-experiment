FROM node:15.7-buster-slim

# apache setup copied from https://github.com/codeurs/dockerfiles/blob/master/mod-neko/Dockerfile
RUN apt-get update && apt-get install -y git curl imagemagick apache2 haxe libapache2-mod-neko \
    libxml-twig-perl libutf8-all-perl && apt-get clean

ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data
ENV APACHE_LOG_DIR=/var/log/apache2

# This value should be overridden by CI/CD
ENV VERSION=unknown

# redirect all logs to stdtout
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log

RUN a2enmod rewrite
RUN a2enmod neko

RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

COPY apache.conf /etc/apache2/sites-available/cagette.conf

RUN a2ensite cagette

RUN npm install -g lix

RUN chown www-data:www-data /srv /var/www

RUN haxelib setup /usr/share/haxelib
RUN haxelib install templo
# this produces a temploc2 executable in current directory, hence the cd /usr/bin
RUN cd /usr/bin && haxelib run templo

# WHY: src/App.hx:20: characters 58-84 : Cannot execute `git log -1 --format=%h`. fatal: not a git repository (or any of the parent directories): .git
# TODO: remove
COPY --chown=www-data:www-data .git /srv/.git

COPY --chown=www-data:www-data common/ /srv/common/
COPY --chown=www-data:www-data data/ /srv/data/
COPY --chown=www-data:www-data devLibs/ /srv/devLibs/
COPY --chown=www-data:www-data js/ /srv/js/
COPY --chown=www-data:www-data lang/ /srv/lang/
COPY --chown=www-data:www-data src/ /srv/src/
COPY --chown=www-data:www-data www/ /srv/www/
COPY --chown=www-data:www-data plugins/ /srv/plugins/

USER www-data

COPY --chown=www-data:www-data backend/ /srv/backend/
WORKDIR /srv/backend

RUN lix scope create
RUN lix install haxe 4.0.5
RUN lix use haxe 4.0.5
RUN lix download

COPY --chown=www-data:www-data frontend/ /srv/frontend/

WORKDIR /srv/frontend

RUN lix scope create
RUN lix use haxe 4.0.5
RUN lix download
RUN npm install

WORKDIR /srv
COPY config.xml.dist config.xml

WORKDIR /srv/backend

RUN haxe build.hxml -D i18n_generation;

WORKDIR /srv/frontend
RUN haxe build.hxml

WORKDIR /srv/lang/fr/tpl/
RUN neko ../../../backend/temploc2.n -macros macros.mtt -output ../tmp/ *.mtt */*.mtt */*/*.mtt */*/*/*.mtt */*/*/*/*.mtt

EXPOSE 3009

WORKDIR /srv

# holds connexion config
COPY --chown=www-data:www-data scripts/ /srv/scripts/
COPY config.xml.dist config-raw.xml

USER root

CMD ["bash", "scripts/start.sh", "config-raw.xml", "config.xml" ]
