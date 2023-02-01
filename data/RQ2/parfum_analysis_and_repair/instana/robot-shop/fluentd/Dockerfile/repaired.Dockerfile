FROM fluentd
USER root
RUN apk update && \
    apk add --no-cache --virtual .build-dependencies build-base ruby-dev

RUN fluent-gem install fluent-plugin-elasticsearch && \
    fluent-gem install fluent-plugin-kubernetes_metadata_filter  && \
    fluent-gem install fluent-plugin-multi-format-parser

