FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.3

ARG HTTPS_PROXY
ARG HTTP_PROXY
ARG https_proxy
ARG http_proxy
ARG no_proxy

ENV https_proxy=${https_proxy}
ENV http_proxy=${http_proxy}
ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}
ENV no_proxy="elastic,mongodb"

USER root

RUN mkdir -p /var/lib/elasticsearch/
RUN mkdir -p /var/lib/elasticsearch/mapping
RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/
RUN mkdir -p /var/log/elasticsearch/

ADD docker-configs/elastic/ /opt/scot/elastic
RUN chown elasticsearch:elasticsearch config/elasticsearch.yml
RUN chown elasticsearch:elasticsearch /opt/scot/elastic
RUN chmod -R +x /opt/scot/elastic/*.sh

USER elasticsearch


ADD docker-configs/elastic/elasticsearch.yml /usr/share/elasticsearch/config/


EXPOSE 9200 9300

CMD /opt/scot/elastic/run.sh