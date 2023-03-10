FROM eboraas/apache
MAINTAINER Ed Boraas <ed@boraas.ca>

RUN apt-get update && apt-get -y --no-install-recommends install apt-transport-https curl php5 php5-mysql && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/a2dismod 'mpm_*' && /usr/sbin/a2enmod mpm_prefork

# Enable mod rewrite
RUN a2enmod rewrite

RUN mkdir -p /var/www/html
WORKDIR /var/www/html
VOLUME /var/www/html/

# Elastic Beats
# Filebeat
RUN curl -f -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.1.2-amd64.deb && dpkg -i filebeat-5.1.2-amd64.deb
ADD ./filebeat.yml /etc/filebeat/filebeat.yml

# Packetbeat
RUN curl -f -L -O https://artifacts.elastic.co/downloads/beats/packetbeat/packetbeat-5.1.2-amd64.deb && dpkg -i packetbeat-5.1.2-amd64.deb
ADD ./packetbeat.yml /etc/packetbeat/packetbeat.yml


EXPOSE 80
EXPOSE 443

ADD start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]