FROM ubuntu
COPY WebServer /
COPY docsite/ /srv/www/
ENV WEBSERVER_DOC_DIR=/srv/www
ENTRYPOINT ["/WebServer"]