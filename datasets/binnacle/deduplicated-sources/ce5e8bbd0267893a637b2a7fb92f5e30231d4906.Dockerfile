# KeeWeb official docker container
# https://keeweb.info
# (C) Antelle 2017, MIT license https://github.com/keeweb/keeweb
# Based on nginx-ssl-secure https://github.com/MarvAmBass/docker-nginx-ssl-secure/

# Building locally:
# docker build -t keeweb .
# docker run --name keeweb -d -p 443:443 -p 80:80 -e 'DH_SIZE=512' -v $EXT_DIR:/etc/nginx/external/ keeweb

# Using pre-built image from dockerhub:
# If you have SSL certs, put your dh.pem, cert.pem, key.pem to /etc/nginx/external/ and run with:
# docker run --name keeweb -d -p 443:443 -p 80:80 -v $EXT_DIR:/etc/nginx/external/ antelle/keeweb
# Or, to generate self-signed cert, run:
# docker run --name keeweb -d -p 443:443 -p 80:80 -e 'DH_SIZE=512' antelle/keeweb

FROM nginx:stable
MAINTAINER Antelle "antelle.net@gmail.com"

# install
RUN apt-get -y update && apt-get -y install openssl wget unzip

# setup nginx
RUN rm -rf /etc/nginx/conf.d/*; \
    mkdir -p /etc/nginx/external

RUN sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf; \
    sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf; \
    sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf

ADD keeweb.conf /etc/nginx/conf.d/keeweb.conf

ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod a+x /opt/entrypoint.sh

# clone keeweb
RUN wget https://github.com/keeweb/keeweb/archive/gh-pages.zip; \
    unzip gh-pages.zip; \
    rm gh-pages.zip; \
    mv keeweb-gh-pages keeweb; \
    rm keeweb/CNAME

# clone keeweb plugins
RUN wget https://github.com/keeweb/keeweb-plugins/archive/master.zip; \
    unzip master.zip; \
    rm master.zip; \
    mv keeweb-plugins-master/docs keeweb/plugins; \
    rm -rf keeweb-plugins-master \
    rm keeweb/plugins/CNAME

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["nginx"]

EXPOSE 443
EXPOSE 80
