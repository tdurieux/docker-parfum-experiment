# arxiv/eleasticsearch
#
# Runs Elasticsearch 6.2.4, with additional plugins.
#
# To run, use the ``docker-compose.yml`` config in this directory to spin up
# alongside Kibana. Or:
#
# $ docker build . -t arxiv/elasticsearch -f ./Dockerfil-elasticsearch
# $ docker run -it -p 9200:9200 -p 9300:9300 \
# >     -e "http.host=0.0.0.0" -e "transport.host=127.0.0.1" \
# >     arxiv/elasticsearch
#
# ES should be available on tcp://localhost:9200.

FROM docker.elastic.co/elasticsearch/elasticsearch:6.2.4

# Install plugins.
#
# This adds the International Components for Unicode analyzer, which is not
# bundled with ES by default. For more information, see
# https://www.elastic.co/guide/en/elasticsearch/plugins/master/analysis-icu.html