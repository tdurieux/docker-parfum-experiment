FROM docker.elastic.co/elasticsearch/elasticsearch:6.5.4

RUN yum -y install sudo

# Delete all x-pack modules
RUN find modules -type d -name "x-pack-*" -exec rm -r {} +

COPY --chown=elasticsearch:elasticsearch component/elasticsearch.yml /usr/share/elasticsearch/config/
ADD component/setup.sh /setup.sh
COPY --chown=elasticsearch:elasticsearch component/wn_s.pl /usr/share/elasticsearch/config/analysis/
COPY --chown=elasticsearch:elasticsearch component/regionSynonyms.txt /usr/share/elasticsearch/config/analysis/
#RUN apk add --no-cache --update curl procps
ENV REPO /snapshots

CMD ["/setup.sh"]