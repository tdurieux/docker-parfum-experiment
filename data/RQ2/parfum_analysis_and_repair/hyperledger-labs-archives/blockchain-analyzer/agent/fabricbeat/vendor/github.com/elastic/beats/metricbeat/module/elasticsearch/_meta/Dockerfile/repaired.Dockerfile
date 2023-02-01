FROM docker.elastic.co/elasticsearch/elasticsearch:7.0.0
HEALTHCHECK CMD [ curl -f https://localhost:9200/_license]
