FROM jprjr/ubuntu-base:14.04
MAINTAINER John Regan <john@jrjrtech.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    echo "deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main" > /etc/apt/sources.list.d/mongodb.list && \
    sudo apt-key adv --fetch-keys "http://packages.elasticsearch.org/GPG-KEY-elasticsearch" && \
    apt-get update && \
    apt-get -y --no-install-recommends install elasticsearch default-jre-headless && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /etc/s6/elasticsearch && \
    ln -s /bin/true /etc/s6/elasticsearch/finish

ADD elasticsearch.run /etc/s6/elasticsearch/run
COPY conf /opt/elasticsearch.default


EXPOSE 9200
EXPOSE 9300
