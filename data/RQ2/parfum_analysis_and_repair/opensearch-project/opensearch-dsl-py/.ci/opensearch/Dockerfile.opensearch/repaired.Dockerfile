ARG OPENSEARCH_VERSION
FROM opensearchproject/opensearch:${OPENSEARCH_VERSION}

COPY --chown=opensearch:opensearch opensearch.yml /usr/share/opensearch/config/

ARG opensearch_path=/usr/share/opensearch
ARG opensearch_yml=$opensearch_path/config/opensearch.yml

ARG SECURE_INTEGRATION
RUN if [ "$SECURE_INTEGRATION" != "true" ] ; then /usr/share/opensearch/bin/opensearch-plugin remove opensearch-security; fi