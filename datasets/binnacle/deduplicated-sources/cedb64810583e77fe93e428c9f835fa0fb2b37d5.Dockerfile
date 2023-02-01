# Elasticsearch %%ELASTICSEARCH_VERSION%%

# This image re-bundles the Docker image from the upstream provider, Elastic. 
FROM %%UPSTREAM_IMAGE_DIGEST%%

# The upstream image was built by:
#   %%UPSTREAM_DOCKERFILE_LINK%%

# For a full list of supported images and tags visit https://www.docker.elastic.co

# For Elasticsearch documentation visit https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html

# See https://github.com/docker-library/official-images/pull/4916 for more details.
