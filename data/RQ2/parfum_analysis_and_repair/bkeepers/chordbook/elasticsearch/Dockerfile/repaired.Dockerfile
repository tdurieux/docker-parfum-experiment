# The official Elasticsearch Docker image
FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.5

# Copy our config file over
COPY --chown=1000:0 config.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Allow Elasticsearch to create `elasticsearch.keystore`
# to circumvent https://github.com/elastic/ansible-elasticsearch/issues/430