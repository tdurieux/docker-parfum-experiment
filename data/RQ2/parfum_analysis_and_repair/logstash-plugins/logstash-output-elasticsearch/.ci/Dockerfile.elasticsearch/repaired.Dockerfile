ARG ELASTIC_STACK_VERSION
FROM docker.elastic.co/elasticsearch/elasticsearch:$ELASTIC_STACK_VERSION

ARG plugin_path=/usr/share/plugins/plugin
ARG es_path=/usr/share/elasticsearch
ARG es_yml=$es_path/config/elasticsearch.yml
ARG SECURE_INTEGRATION
ARG ES_SSL_KEY_INVALID
ARG ES_SSL_SUPPORTED_PROTOCOLS

RUN rm -f $es_path/config/scripts

COPY --chown=elasticsearch:elasticsearch spec/fixtures/test_certs/* $es_path/config/test_certs/
COPY --chown=elasticsearch:elasticsearch .ci/elasticsearch-run.sh $es_path/

RUN if [ "$SECURE_INTEGRATION" != "true" ] ; then echo "xpack.security.enabled: false" >> $es_yml; fi

RUN if [ "$SECURE_INTEGRATION" = "true" ] ; then echo "xpack.security.http.ssl.enabled: $SECURE_INTEGRATION" >> $es_yml; fi
RUN if [ "$SECURE_INTEGRATION" = "true" ] ; then \
      if [ "$ES_SSL_KEY_INVALID" = "true" ] ; then \
        echo "xpack.security.http.ssl.key: $es_path/config/test_certs/test_invalid.key" >> $es_yml; \
        echo "xpack.security.http.ssl.certificate: $es_path/config/test_certs/test_invalid.crt" >> $es_yml; \
      else \
        echo "xpack.security.http.ssl.key: $es_path/config/test_certs/test.key" >> $es_yml; \
        echo "xpack.security.http.ssl.certificate: $es_path/config/test_certs/test.crt" >> $es_yml; \
      fi \
    fi
RUN if [ "$SECURE_INTEGRATION" = "true" ] ; then echo "xpack.security.http.ssl.certificate_authorities: [ '$es_path/config/test_certs/ca.crt' ]" >> $es_yml; fi
RUN if [ "$SECURE_INTEGRATION" = "true" ] && [ ! -z "$ES_SSL_SUPPORTED_PROTOCOLS" ] ; then echo "xpack.security.http.ssl.supported_protocols: ${ES_SSL_SUPPORTED_PROTOCOLS}" >> $es_yml; fi

RUN cat $es_yml

RUN if [ "$SECURE_INTEGRATION" = "true" ] ; then $es_path/bin/elasticsearch-users useradd admin -p elastic -r superuser; fi
RUN if [ "$SECURE_INTEGRATION" = "true" ] ; then $es_path/bin/elasticsearch-users useradd simpleuser -p abc123 -r superuser; fi
RUN if [ "$SECURE_INTEGRATION" = "true" ] ; then $es_path/bin/elasticsearch-users useradd 'f@ncyuser' -p 'ab%12#' -r superuser; fi