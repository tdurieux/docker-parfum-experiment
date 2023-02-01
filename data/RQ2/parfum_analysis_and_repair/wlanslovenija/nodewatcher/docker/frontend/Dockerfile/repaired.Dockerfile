FROM wlanslovenija/nodewatcher-base

MAINTAINER Jernej Kos <jernej@kos.mx>

EXPOSE 80/tcp

RUN apt-get update -q -q && \
 apt-get install --no-install-recommends -y uwsgi-plugin-python nginx-full && rm -rf /var/lib/apt/lists/*;

COPY ./etc /etc

