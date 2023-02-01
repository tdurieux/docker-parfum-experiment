FROM vproxyio/runtime:latest

RUN apt-get install --no-install-recommends -y ethtool && rm -rf /var/lib/apt/lists/*;

ADD init.sh /init.sh
ADD default-mirror.json /default-mirror.json
ADD vproxy.jar /vproxy.jar

RUN chmod +x /init.sh

RUN mkdir -p /dev/net
RUN mkdir -p /var/run/docker
RUN mkdir -p /x-etc

ENTRYPOINT []
CMD []
