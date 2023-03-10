FROM ubuntu:14.04
MAINTAINER Andrei Vacariu <andrei@avacariu.me>

# MAINTAIN THE SAME ORDER OF USER CREATION BETWEEN ALL DOCKERFILES SO THAT THEY
# ALL END UP WITH THE SAME UID/GID
RUN groupadd -r lensing \
  && useradd -r -s /bin/false -g lensing lensing

RUN mkdir -p /data/db
RUN chown -R www-data:www-data /data/db

RUN mkdir -p /data/index
RUN chown -R lensing:lensing /data/index

VOLUME ["/data/index", "/data/db"]

CMD "/bin/true"