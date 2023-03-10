# This Dockerfile was generated from templates/Dockerfile.j2
FROM centos:7

# Install Java and the "which" command, which is needed by Logstash's shell
# scripts.
# Minimal distributions also require findutils tar gzip (procps for integration tests)

# on aarch64, yum does not pick the right `bind-license` package for some reason
# here we install a specific noarch RPM.
RUN for iter in {1..10}; do yum update -y && \
    yum install -y procps findutils tar gzip which shadow-utils && \
    yum clean all && \
yum clean metadata && \
exit_code=0 && break || exit_code=$? && \
    echo "packaging error: retry $iter in 10s" && \
    yum clean all && \
yum clean metadata && \
sleep 10; done; rm -rf /var/cache/yum \
    (exit $exit_code)

# Provide a non-root user to run the process.
RUN groupadd --gid 1000 logstash && \
    adduser --uid 1000 --gid 1000 \
      --home-dir /usr/share/logstash --no-create-home \
      logstash

COPY java.sh /etc/profile.d/

# Add Logstash itself.
RUN curl -f -Lo - https://artifacts.elastic.co/downloads/logstash/logstash-7.14.0-linux-$(arch).tar.gz | \
    tar zxf - -C /usr/share && \
    mv /usr/share/logstash-7.14.0 /usr/share/logstash && \
    chown --recursive logstash:logstash /usr/share/logstash/ && \
    chown -R logstash:root /usr/share/logstash && \
    chmod -R g=u /usr/share/logstash && \
    mkdir /licenses/ && \
    mv /usr/share/logstash/NOTICE.TXT /licenses/NOTICE.TXT && \
    mv /usr/share/logstash/LICENSE.txt /licenses/LICENSE.txt && \
    find /usr/share/logstash -type d -exec chmod g+s {} \; && \
    ln -s /usr/share/logstash /opt/logstash


WORKDIR /usr/share/logstash

ENV ELASTIC_CONTAINER true
ENV PATH=/usr/share/logstash/bin:$PATH

ARG JAVA_HOME=/usr/share/logstash/jdk \
    PATH=$PATH:$JAVA_HOME/bin \
    CLASSPATH=.:$JAVA_HOME/lib

#install plugins
RUN bin/logstash-plugin install logstash-input-sls

RUN bin/logstash-plugin install logstash-filter-geoip

RUN bin/logstash-plugin install logstash-output-loki
RUN bin/logstash-plugin install logstash-output-s3
RUN bin/logstash-plugin install logstash-output-oss
#AWS openseach
RUN bin/logstash-plugin install logstash-output-opensearch
#Web hdfs output for logstash
RUN bin/logstash-plugin install logstash-output-webhdfs
RUN bin/logstash-plugin install logstash-output-opentsdb
#The plugin makes possible to store logs in ceph.
#RUN bin/logstash-plugin install logstash-output-rados
RUN bin/logstash-plugin install logstash-output-zabbix
RUN bin/logstash-plugin install logstash-output-influxdb

# Provide a minimal configuration, so that simple invocations will provide
# a good experience.
ADD config/jvm.options config/jvm.options
ADD config/pipelines.yml config/pipelines.yml
ADD config/logstash-full.yml config/logstash.yml
ADD config/log4j2.properties config/
ADD pipeline/default.conf pipeline/logstash.conf
RUN chown --recursive logstash:root config/ pipeline/

# Ensure Logstash gets the correct locale by default.
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Place the startup wrapper script.
ADD bin/docker-entrypoint /usr/local/bin/
RUN chmod 0755 /usr/local/bin/docker-entrypoint

USER 1000

ADD env2yaml/env2yaml /usr/local/bin/

EXPOSE 9600 5044


LABEL  org.label-schema.schema-version="1.0" \
  org.label-schema.vendor="Elastic" \
  org.opencontainers.image.vendor="Elastic" \
  org.label-schema.name="logstash" \
  org.opencontainers.image.title="logstash" \
  org.label-schema.version="7.14.0" \
  org.opencontainers.image.version="7.14.0" \
  org.label-schema.url="https://www.elastic.co/products/logstash" \
  org.label-schema.vcs-url="https://github.com/elastic/logstash" \
  org.label-schema.license="Elastic License" \
  org.opencontainers.image.licenses="Elastic License" \
  org.opencontainers.image.description="Logstash is a free and open server-side data processing pipeline that ingests data from a multitude of sources, transforms it, and then sends it to your favorite 'stash.'" \
  org.label-schema.build-date=2021-07-29T19:43:14Z \
org.opencontainers.image.created=2021-07-29T19:43:14Z


ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
