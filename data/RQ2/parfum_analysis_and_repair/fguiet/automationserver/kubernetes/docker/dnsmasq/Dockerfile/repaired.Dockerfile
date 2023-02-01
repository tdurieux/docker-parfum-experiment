FROM balenalib/raspberry-pi:buster

RUN apt-get clean && apt-get update && apt-get upgrade

RUN apt-get -q --no-install-recommends -y install dnsmasq && rm -rf /var/lib/apt/lists/*;

ADD ./conf/ /etc

EXPOSE 53/udp

CMD dnsmasq -k