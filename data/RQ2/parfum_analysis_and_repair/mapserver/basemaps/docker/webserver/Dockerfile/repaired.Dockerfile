FROM debian:stretch

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    mapserver-bin cgi-mapserver apache2 libapache2-mod-fcgid \
    git make build-essential python wget unzip && rm -rf /var/lib/apt/lists/*;

RUN a2enmod alias fcgid cgid

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

WORKDIR /app   

CMD ["/run-httpd.sh"]