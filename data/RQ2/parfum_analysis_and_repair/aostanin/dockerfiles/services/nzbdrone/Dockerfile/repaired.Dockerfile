FROM ubuntu:trusty

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FDA5DFFC && \
    echo 'deb http://apt.sonarr.tv/ master main' > /etc/apt/sources.list.d/nzbdrone.list && \
    apt-get update -q

RUN apt-get install --no-install-recommends -qy libmono-cil-dev nzbdrone && rm -rf /var/lib/apt/lists/*;

ADD start.sh /start.sh

VOLUME ["/data"]
EXPOSE 8989

CMD ["/start.sh"]
