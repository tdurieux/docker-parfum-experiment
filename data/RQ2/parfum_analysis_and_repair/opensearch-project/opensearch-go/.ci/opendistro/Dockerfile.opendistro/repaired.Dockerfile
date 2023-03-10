ARG OPENDISTRO_VERSION
FROM amazon/opendistro-for-elasticsearch:${OPENDISTRO_VERSION}

ARG es_path=/usr/share/elasticsearch

ARG SECURE_INTEGRATION
RUN if [ "$SECURE_INTEGRATION" != "true" ] ; then $es_path/bin/elasticsearch-plugin remove opendistro_security; fi