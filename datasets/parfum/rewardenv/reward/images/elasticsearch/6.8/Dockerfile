FROM docker.elastic.co/elasticsearch/elasticsearch:6.8.18

RUN set -eux \
    && bin/elasticsearch-plugin install analysis-phonetic \
    && bin/elasticsearch-plugin install analysis-icu
