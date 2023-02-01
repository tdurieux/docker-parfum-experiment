FROM debian:10

ARG DOMAIN

# System setup
RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2 gnupg curl ntp && \
    apt-get install --no-install-recommends -y certbot python-certbot-apache && \
    curl --fail --remote-name https://pkg.switch.ch/switchaai/debian/dists/buster/main/binary-all/misc/switchaai-apt-source_1.0.0_all.deb && \
    apt-get install --no-install-recommends -y ./switchaai-apt-source_1.0.0_all.deb && \
    rm ./switchaai-apt-source_1.0.0_all.deb && \
    apt-get update && \
    apt-get install -y --install-recommends shibboleth && rm -rf /var/lib/apt/lists/*;

# Shibboleth setup
RUN mkdir /etc/shibboleth/certs
COPY configs/shibboleth2.xml /etc/shibboleth/shibboleth2.xml
COPY configs/inc-md-cert-mdq.pem /etc/shibboleth/inc-md-cert-mdq.pem

# Server setup
COPY configs/puzzlehunt_apache_shib.conf /etc/apache2/sites-available/puzzlehunt.conf
RUN rm /etc/apache2/sites-enabled/* && \
    sed -i -e "s/REPLACE_DOMAIN_STR/$DOMAIN/g" /etc/apache2/sites-available/puzzlehunt.conf && \
    sed -i -e "s/REPLACE_DOMAIN_STR/$DOMAIN/g" /etc/shibboleth/shibboleth2.xml && \
    apt-get install --no-install-recommends -y libapache2-mod-xsendfile libapache2-mod-shib && \
    a2enmod proxy proxy_http proxy_html xsendfile shib && \
    a2ensite puzzlehunt && \
    mkdir -p /static && \
    mkdir -p /media && rm -rf /var/lib/apt/lists/*;

COPY apacheShibForeground /usr/local/bin/
RUN chmod +x /usr/local/bin/apacheShibForeground

EXPOSE 80

CMD ["/usr/local/bin/apacheShibForeground"]