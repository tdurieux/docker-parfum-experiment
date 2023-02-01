FROM docker-dev.yelpcorp.com/trusty_yelp
MAINTAINER Team Distributed Systems <team-dist-sys@yelp.com>

RUN apt-get update && apt-get -y --no-install-recommends install zookeeper && rm -rf /var/lib/apt/lists/*;

CMD /usr/share/zookeeper/bin/zkServer.sh start-foreground
