# Logstash %%VERSION%%

# This image re-bundles the Docker image from the upstream provider, Elastic.
FROM %%UPSTREAM_IMAGE_DIGEST%%
# Supported Bashbrew Architectures: %%UPSTREAM_IMAGE_ARCHITECTURES%%

# The upstream image was built by:
#   %%UPSTREAM_DOCKERFILE_LINK%%

# The build can be reproduced locally via:
#   docker build '%%UPSTREAM_DOCKER_BUILD%%'

# For a full list of supported images and tags visit https://www.docker.elastic.co

# For Logstash documentation visit https://www.elastic.co/guide/en/logstash/current/docker.html

# See https://github.com/docker-library/official-images/pull/5039 for more details.