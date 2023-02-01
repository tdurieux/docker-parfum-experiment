FROM docker.elastic.co/elasticsearch/elasticsearch:7.5.1
LABEL maintainer="Charlie Lewis <clewis@iqt.org>" \
      vent="" \
      vent.name="elasticsearch" \
      vent.groups="search" \
      vent.repo="https://github.com/cyberreboot/vent" \
      vent.type="repository"

HEALTHCHECK CMD [ curl --silent --fail https://localhost:9200/_cluster/health || exit 1]

