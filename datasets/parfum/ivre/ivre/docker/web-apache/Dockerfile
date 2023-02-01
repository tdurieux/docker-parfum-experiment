# This file is part of IVRE.
# Copyright 2011 - 2021 Pierre LALET <pierre@droids-corp.org>
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

ARG TAG=latest
FROM ivre/base:${TAG}
LABEL maintainer="Pierre LALET <pierre@droids-corp.org>"

# Install Apache2 & Dokuwiki
RUN apt-get -q update && \
    apt-get -qy --no-install-recommends install apache2 libapache2-mod-wsgi-py3 \
        dokuwiki && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add links for IVRE Web UI
RUN rm var/www/html/index.html && \
    ln -s /usr/local/share/ivre/web/static/* var/www/html && \
    for d in "" /local; do \
      if [ -f "/usr$d/share/ivre/web/wsgi/app.wsgi" ]; then \
        echo "Alias /cgi \"/usr$d/share/ivre/web/wsgi/app.wsgi\"" \
          > etc/apache2/conf-enabled/ivre.conf; fi; done && \
    echo '<Location /cgi>' >> etc/apache2/conf-enabled/ivre.conf && \
    echo 'SetHandler wsgi-script' >> etc/apache2/conf-enabled/ivre.conf && \
    echo 'Options +ExecCGI' >> etc/apache2/conf-enabled/ivre.conf && \
    echo 'Require all granted' >> etc/apache2/conf-enabled/ivre.conf && \
    echo '</Location>' >> etc/apache2/conf-enabled/ivre.conf && \
    ln -s /usr/local/share/ivre/dokuwiki/media/logo.png var/lib/dokuwiki/data/media/wiki

# Configure IVRE
RUN echo 'WEB_GET_NOTEPAD_PAGES = "localdokuwiki"' >> /etc/ivre.conf

# Patch Dokuwiki for backlinks to IVRE results
RUN apt-get update && \
    apt-get -qy --no-install-recommends install patch && \
    cd usr/share/dokuwiki && \
    patch -p0 < /usr/local/share/ivre/patches/dokuwiki/backlinks.patch && \
    apt-get -qy --purge autoremove patch && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure Apache for server-side URL rewrite
RUN sed -i 's/^\(\s*\)#Rewrite/\1Rewrite/' etc/dokuwiki/apache.conf
RUN ln -s /etc/apache2/mods-available/rewrite.load etc/apache2/mods-enabled

# Configure Dokuwiki (access to everyone)
RUN mv etc/dokuwiki/acl.auth.php.dist etc/dokuwiki/acl.auth.php
RUN sed -i 's/Allow from localhost.*/Allow from all/' etc/dokuwiki/apache.conf
COPY doku-conf-local.php etc/dokuwiki/local.php

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80
CMD exec /usr/sbin/apache2 -D FOREGROUND
