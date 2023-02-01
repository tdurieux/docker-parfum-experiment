FROM ubuntu:xenial

# utils
RUN apt-get update && apt-get install --no-install-recommends --yes debconf-utils wget apache2 collectd && rm -rf /var/lib/apt/lists/*;

# preseed graphite remove database question
RUN echo "graphite-carbon graphite-carbon/postrm_remove_databases boolean false" | debconf-set-selections
# install graphite
RUN apt-get update && apt-get install --no-install-recommends --yes graphite-carbon graphite-web libapache2-mod-wsgi && rm -rf /var/lib/apt/lists/*;

# install grafana
RUN wget https://dl.grafana.com/oss/release/grafana_6.1.3_amd64.deb
RUN dpkg -i grafana_6.1.3_amd64.deb

# collectd configuration
COPY ./config/collectd.conf /etc/collectd/

# grafana-web configuration
RUN cp /usr/share/graphite-web/apache2-graphite.conf /etc/apache2/sites-available

# regenerate graphite-web database
RUN graphite-manage migrate --noinput
RUN chown _graphite:_graphite /var/lib/graphite/graphite.db

# apache configuration
RUN a2dissite 000-default
RUN a2ensite apache2-graphite

# entrypoint
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

