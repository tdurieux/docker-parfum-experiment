FROM ubuntu:14.04
MAINTAINER Andrei Vacariu <andrei@avacariu.me>

# MAINTAIN THE SAME ORDER OF USER CREATION BETWEEN ALL DOCKERFILES SO THAT THEY
# ALL END UP WITH THE SAME UID/GID
RUN groupadd -r lensing \
  && useradd -r -s /bin/false -g lensing lensing

ENV DEBIAN_FRONTEND noninteractive

# XXX: Uncomment this if it's convenient for you, but it's not good for
# production because sometimes you get "Hash sum mismatch"
#RUN sed -i 's;archive.ubuntu.com;mirror.its.sfu.ca/mirror;' /etc/apt/sources.list

RUN apt-get update && apt-get install --no-install-recommends -y python2.7 python-pip python-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gevent uwsgi

ADD . /opt/lensing
RUN pip install --no-cache-dir -r /opt/lensing/requirements.txt

USER lensing

CMD uwsgi --ini /opt/lensing/uwsgi.ini
