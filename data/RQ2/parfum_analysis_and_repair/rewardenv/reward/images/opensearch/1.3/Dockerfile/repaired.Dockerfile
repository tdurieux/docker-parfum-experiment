FROM opensearchproject/opensearch:1.3.3

RUN set -eux \
    && bin/opensearch-plugin install analysis-phonetic \
    && bin/opensearch-plugin install analysis-icu