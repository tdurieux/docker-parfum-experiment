FROM ubuntu
MAINTAINER Torrie Fischer <torrie@ripple.com>

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends -qq software-properties-common && \
    apt-add-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-add-repository -y ppa:afrank/boost && \
    apt-get update -qq && rm -rf /var/lib/apt/lists/*;

RUN apt-get purge -qq libboost1.48-dev && \
    apt-get install -y --no-install-recommends -qq libprotobuf8 libboost1.57-all-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /srv/rippled/data

VOLUME /srv/rippled/data/

ENTRYPOINT ["/srv/rippled/bin/rippled"]
CMD ["--conf", "/srv/rippled/data/rippled.cfg"]
EXPOSE 51235/udp
EXPOSE 5005/tcp

ADD ./rippled.cfg /srv/rippled/data/rippled.cfg
ADD ./rippled /srv/rippled/bin/
