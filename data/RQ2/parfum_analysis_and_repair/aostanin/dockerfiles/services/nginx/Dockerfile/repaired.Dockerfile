FROM ubuntu:trusty

ENV LANG en_US.UTF-8

RUN locale-gen $LANG

RUN echo 'deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main' > /etc/apt/sources.list.d/nodejs.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C && \
    apt-get update -q && \
    apt-get install --no-install-recommends -qy nginx && rm -rf /var/lib/apt/lists/*;

ADD start.sh /start.sh

VOLUME ["/data"]
EXPOSE 80
EXPOSE 443

CMD ["/start.sh"]
