FROM glanf/base
MAINTAINER Simon Jouet

RUN apt-get update && apt-get install --no-install-recommends -y python snort supervisor && rm -rf /var/lib/apt/lists/*;

RUN mkdir /data
ADD logrunner.py /data/
ADD supervisord.conf /etc/supervisor/
ADD snort.conf /etc/snort/

ENTRYPOINT ifinit && /usr/bin/supervisord