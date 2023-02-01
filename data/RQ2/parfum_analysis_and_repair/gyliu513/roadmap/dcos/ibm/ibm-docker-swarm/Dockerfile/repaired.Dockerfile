FROM ubuntu

MAINTAINER Klaus Ma <klaus1982.cn@gmail.com>
MAINTAINER Yong Feng <yongfeng@ca.ibm.com>

RUN apt-get update && apt-get install --no-install-recommends -yq supervisor && rm -rf /var/lib/apt/lists/*;

ADD ./godep/bin/swarm /opt/
ADD ./bootstrap.sh /opt/
RUN chmod +x /opt/bootstrap.sh

WORKDIR /opt

ENTRYPOINT ["./bootstrap.sh"]

