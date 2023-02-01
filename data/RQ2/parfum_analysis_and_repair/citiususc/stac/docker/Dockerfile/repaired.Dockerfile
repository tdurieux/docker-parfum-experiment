FROM ubuntu:14.04.1
MAINTAINER ismael.rodriguez

RUN apt-get update && apt-get install --no-install-recommends -y python-scipy python-networkx python-pygraphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y apache2 libapache2-mod-wsgi && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://gitlab.citius.usc.es/ismael.rodriguez/stac.git
RUN mkdir /var/www/stac
RUN cp -R stac/api stac/web stac/stac /var/www/stac/
RUN chmod -R 755 /var/www/stac

ADD stac.conf /etc/apache2/sites-enabled/000-default.conf
EXPOSE 80

CMD /usr/sbin/apache2ctl -D FOREGROUND
