FROM fedora
MAINTAINER http://fedoraproject.org/wiki/Cloud
RUN dnf -y update && dnf clean all
RUN dnf -y install httpd php php-mysql php-gd pwgen psmisc tar && \
    dnf clean all

ADD scripts /scripts
RUN curl -f -LO http://wordpress.org/latest.tar.gz && \
    tar xvzf /latest.tar.gz -C /var/www/html --strip-components=1 && \
    rm /latest.tar.gz && \
    chown -R apache:apache /var/www/ && \
    chmod 755 /scripts/*

VOLUME ["/var/www/html/wp-content", "/var/log/httpd"]
EXPOSE 80

CMD ["/bin/bash", "/scripts/start.sh"]
