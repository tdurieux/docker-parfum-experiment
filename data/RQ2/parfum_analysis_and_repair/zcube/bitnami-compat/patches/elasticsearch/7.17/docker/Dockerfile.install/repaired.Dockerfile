# Reference : https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html

RUN install_packages wget

ENV ELASTICSEARCH_VERSION {{{VERSION}}}

ENV ES_JAVA_HOME=/opt/bitnami/java

RUN mkdir -p /opt/bitnami \
    && cd /opt/bitnami \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-$(uname -m).tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-$(uname -m).tar.gz.sha512 \
    && cat elasticsearch-${ELASTICSEARCH_VERSION}-linux-$(uname -m).tar.gz.sha512 | sha512sum --check - \
    && tar -xzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-$(uname -m).tar.gz \
    && mv elasticsearch-${ELASTICSEARCH_VERSION}/ elasticsearch \
    && rm -rf elasticsearch-${ELASTICSEARCH_VERSION}-linux-$(uname -m)* \
    && chown 1001:1001 -R /opt/bitnami/elasticsearch && rm elasticsearch-${ELASTICSEARCH_VERSION}-linux-$( uname -m).tar.gz
