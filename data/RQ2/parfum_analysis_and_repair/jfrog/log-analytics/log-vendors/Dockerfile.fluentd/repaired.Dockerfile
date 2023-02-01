FROM bitnami/fluentd
LABEL maintainer "Partner Engineering <cpe-admin@jfrog.com>"
USER root
## Install custom Fluentd plugins
RUN fluent-gem install 'fluent-plugin-datadog'
RUN fluent-gem install 'fluent-plugin-splunk-enterprise'
RUN fluent-gem install 'fluent-plugin-elasticsearch'