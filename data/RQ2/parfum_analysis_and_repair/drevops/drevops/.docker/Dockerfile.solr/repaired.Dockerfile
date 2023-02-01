# Solr container.
ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

# @see https://hub.docker.com/r/uselagoon/solr/tags?page=1&name=drupal
# @see https://github.com/uselagoon/lagoon-images/tree/main/images/solr-drupal
FROM uselagoon/solr-7.7-drupal:22.4.1

# Based off search_api_solr/solr-conf-templates/7.x as a sane default.