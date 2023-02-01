#We want the same base image as back service to minimize space
FROM python:3-stretch

RUN apt-get -qq -y update && \
    apt-get -y --no-install-recommends install wget && \
 wget -qO - https://icecast.org/multimedia-obs.key | apt-key add - && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://download.opensuse.org/repositories/multimedia:/xiph/Debian_9.0/ ./" > /etc/apt/sources.list.d/icecast.list
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y icecast2 && rm -rf /var/lib/apt/lists/*;

EXPOSE 8000 8001

RUN mkdir /config

ENV ICECAST_LOCATION Earth
ENV ICECAST_ADMIN icemaster@localhost
ENV ICECAST_CLIENTS 100
ENV ICECAST_SOURCES 2
ENV ICECAST_THREADPOOL 5
ENV ICECAST_QUEUE_SIZE 524288
ENV ICECAST_CLIENT_TIMEOUT 30
ENV ICECAST_HEADER_TIMEOUT 15
ENV ICECAST_SOURCE_TIMEOUT 10
ENV ICECAST_BURST_ON_CONNECT 1
ENV ICECAST_BURST_SIZE 65535
ENV ICECAST_SOURCE_PASSWORD hackme
ENV ICECAST_RELAY_PASSWORD hackme
ENV ICECAST_ADMIN_USER admin
ENV ICECAST_ADMIN_PASSWORD hackme
ENV ICECAST_HOSTNAME localhost
ENV ICECAST_PORT 8000
ENV ICECAST_SPORT 8001



ADD startup.sh /usr/local/bin/startup.sh
ADD icecast.xml.template /config/icecast.xml.template

ENTRYPOINT ["/bin/bash", "/usr/local/bin/startup.sh"]
