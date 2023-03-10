################################################################################
# This Dockerfile was generated from the template at .tedi/Dockerfile.j2
#
# Beginning of multi stage Dockerfile
################################################################################

{% set tarball = 'elasticsearch-%s-%s.tar.gz' % (image_flavor, elastic_version) -%}

################################################################################
# Build stage 0 `prep_files`:
# Extract elasticsearch artifact
# Install required plugins
# Set gid=0 and make group perms==owner perms
################################################################################

FROM centos:7 AS prep_files

ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV JAVA_HOME /opt/jdk-{{ jdk_version }}

RUN curl -f -s {{ jdk_url }} | tar -C /opt -zxf -

# Replace OpenJDK's built-in CA certificate keystore with the one from the OS
# vendor. The latter is superior in several ways.
# REF: https://github.com/elastic/elasticsearch-docker/issues/171
RUN ln -sf /etc/pki/ca-trust/extracted/java/cacerts /opt/jdk-{{ jdk_version }}/lib/security/cacerts

RUN yum install -y unzip which && rm -rf /var/cache/yum

RUN groupadd -g 1000 elasticsearch && \
    adduser -u 1000 -g 1000 -d /usr/share/elasticsearch elasticsearch

WORKDIR /usr/share/elasticsearch

COPY {{ tarball }} ingest-user-agent.zip ingest-geoip.zip /opt/
RUN tar zxf /opt/{{ tarball }} --strip-components=1
RUN elasticsearch-plugin install --batch file:///opt/ingest-user-agent.zip
RUN elasticsearch-plugin install --batch file:///opt/ingest-geoip.zip
RUN mkdir -p config data logs
RUN chmod 0775 config data logs
COPY elasticsearch.yml log4j2.properties config/


################################################################################
# Build stage 1 (the actual elasticsearch image):
# Copy elasticsearch from stage 0
# Add entrypoint
################################################################################

FROM centos:7

ENV ELASTIC_CONTAINER true
ENV JAVA_HOME /opt/jdk-{{ jdk_version }}

COPY --from=prep_files /opt/jdk-{{ jdk_version }} /opt/jdk-{{ jdk_version }}

RUN yum update -y && \
    yum install -y nc unzip wget which && \
    yum clean all && rm -rf /var/cache/yum

RUN groupadd -g 1000 elasticsearch && \
    adduser -u 1000 -g 1000 -G 0 -d /usr/share/elasticsearch elasticsearch && \
    chmod 0775 /usr/share/elasticsearch && \
    chgrp 0 /usr/share/elasticsearch

WORKDIR /usr/share/elasticsearch
COPY --from=prep_files --chown=1000:0 /usr/share/elasticsearch /usr/share/elasticsearch
ENV PATH /usr/share/elasticsearch/bin:$PATH

COPY --chown=1000:0 bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Openshift overrides USER and uses ones with randomly uid>1024 and gid=0
# Allow ENTRYPOINT (and ES) to run even with a different user
RUN chgrp 0 /usr/local/bin/docker-entrypoint.sh && \
    chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh

EXPOSE 9200 9300

LABEL org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.name="elasticsearch" \
  org.label-schema.version="{{ elastic_version }}" \
  org.label-schema.url="https://www.elastic.co/products/elasticsearch" \
  org.label-schema.vcs-url="https://github.com/elastic/elasticsearch-docker" \
{% if image_flavor == 'oss' -%}
  license="Apache-2.0"
{% else -%}
  license="Elastic License"
{% endif -%}

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# Dummy overridable parameter parsed by entrypoint
CMD ["eswrapper"]

################################################################################
# End of multi-stage Dockerfile
################################################################################
