# This file is part of IVRE.
# Copyright 2011 - 2018 Pierre LALET <pierre.lalet@cea.fr>
#
# IVRE is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# IVRE is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
# License for more details.
#
# You should have received a copy of the GNU General Public License
# along with IVRE. If not, see <http://www.gnu.org/licenses/>.

FROM ivre/base
LABEL maintainer="Pierre LALET <pierre.lalet@cea.fr>"

# Install & configure Nginx
RUN apt-get -qy install nginx spawn-fcgi php-fpm php-gd fcgiwrap uwsgi-plugin-python
COPY nginx-default-site /etc/nginx/sites-available/default
RUN echo '\ndaemon off;' >> /etc/nginx/nginx.conf
RUN mkdir /var/run/uwsgi

# Download & install Dokuwiki
ADD http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz ./dokuwiki-stable.tgz
RUN tar --transform='s#^dokuwiki-\([^/]*\)#var/www/dokuwiki#' -zxf ./dokuwiki-stable.tgz && rm ./dokuwiki-stable.tgz

# IVRE-specific
RUN apt-get -qy install patch && \
    patch var/www/dokuwiki/inc/html.php usr/local/share/ivre/dokuwiki/backlinks.patch && \
    apt-get -qy --purge autoremove patch
RUN ln -s /usr/local/share/ivre/dokuwiki/doc var/www/dokuwiki/data/pages/doc && \
    ln -s /usr/local/share/ivre/dokuwiki/media/logo.png var/www/dokuwiki/data/media/wiki/logo.png && \
    mkdir var/www/dokuwiki/data/media/doc && \
    ln -s /usr/local/share/doc/ivre/screenshots var/www/dokuwiki/data/media/doc/ && \
    ln -s /usr/local/share/ivre/dokuwiki/media/doc var/www/dokuwiki/data/media/wiki/doc && \
    echo 'WEB_GET_NOTEPAD_PAGES = ("localdokuwiki", ("/var/www/dokuwiki/data/pages",))' >> /etc/ivre.conf

# Configure Dokuwiki
RUN rm var/www/dokuwiki/install.php
COPY doku-conf-local.php var/www/dokuwiki/conf/local.php
COPY doku-conf-plugins.local.php var/www/dokuwiki/conf/plugins.local.php
COPY doku-conf-acl.auth.php var/www/dokuwiki/conf/acl.auth.php
COPY doku-conf-users.auth.php var/www/dokuwiki/conf/users.auth.php
RUN chown -Rh www-data:www-data var/www/dokuwiki/data var/www/dokuwiki/conf var/www/dokuwiki/lib/plugins

# Needed by Neo4j
RUN mkdir /var/www/.neo4j && chown www-data:www-data /var/www/.neo4j

EXPOSE 80
CMD service php7.0-fpm start && \
    service fcgiwrap start && \
    for d in "" /local; do if [ -f "/usr$d/share/ivre/web/wsgi/app.wsgi" ]; \
      then APP="/usr$d/share/ivre/web/wsgi/app.wsgi"; break; fi; done && \
    uwsgi --plugin /usr/lib/uwsgi/plugins/python_plugin.so \
      --daemonize /var/log/nginx/uwsgi.log \
      --socket /var/run/uwsgi/sock \
      --processes 4 --threads 2 \
      --mount /cgi="$APP" --manage-script-name && \
    exec /usr/sbin/nginx
