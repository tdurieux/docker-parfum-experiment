FROM stackbrew/debian:jessie
MAINTAINER Evan Hazlett <ejhazlett@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://dl.4players.de/ts/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz -O /tmp/teamspeak.tar.gz && tar zxf /tmp/teamspeak.tar.gz -C /opt && mv /opt/teamspeak3-server_* /opt/teamspeak && rm /tmp/teamspeak.tar.gz
EXPOSE 9987/udp 10011 30033
VOLUME /opt/teamspeak
CMD ["/opt/teamspeak/ts3server_minimal_runscript.sh"]

