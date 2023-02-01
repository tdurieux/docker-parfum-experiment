FROM ubuntu:16.04

ARG vcs_ref
ARG build_date
ARG version="6.0.0"
# Used by entrypoint to submit metrics to Google Analytics.
# Published images should use "production" for this build_arg.
ARG pupperware_analytics_stream="dev"
ENV PUPPERWARE_ANALYTICS_STREAM="$pupperware_analytics_stream"
ENV PUPPERWARE_ANALYTICS_TRACKING_ID="UA-132486246-4"
ENV PUPPERWARE_ANALYTICS_APP_NAME="puppetserver-standalone"
ENV PUPPERWARE_ANALYTICS_ENABLED=false

ENV PUPPET_SERVER_VERSION="$version"
ENV DUMB_INIT_VERSION="1.2.1"
ENV UBUNTU_CODENAME="xenial"
ENV PUPPETSERVER_JAVA_ARGS="-Xms512m -Xmx512m"
ENV PATH=/opt/puppetlabs/server/bin:/opt/puppetlabs/puppet/bin:/opt/puppetlabs/bin:$PATH
ENV PUPPET_HEALTHCHECK_ENVIRONMENT="production"
ENV PUPPET_MASTERPORT=8140
ENV PUPPETSERVER_MAX_ACTIVE_INSTANCES=1
ENV PUPPETSERVER_MAX_REQUESTS_PER_INSTANCE=0
ENV CA_ENABLED=true

LABEL org.label-schema.maintainer="Puppet Release Team <release@puppet.com>" \
      org.label-schema.vendor="Puppet" \
      org.label-schema.url="https://github.com/puppetlabs/puppetserver" \
      org.label-schema.name="Puppet Server (No PuppetDB)" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version="$PUPPET_SERVER_VERSION" \
      org.label-schema.vcs-url="https://github.com/puppetlabs/puppetserver" \
      org.label-schema.vcs-ref="$vcs_ref" \
      org.label-schema.build-date="$build_date" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Dockerfile"

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget=1.17.1-1ubuntu1 ca-certificates && \
    wget https://apt.puppetlabs.com/puppet6-release-"$UBUNTU_CODENAME".deb && \
    wget https://github.com/Yelp/dumb-init/releases/download/v"$DUMB_INIT_VERSION"/dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    dpkg -i puppet6-release-"$UBUNTU_CODENAME".deb && \
    dpkg -i dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    rm puppet6-release-"$UBUNTU_CODENAME".deb dumb-init_"$DUMB_INIT_VERSION"_amd64.deb && \
    apt-get update && \
    apt-get install --no-install-recommends git -y puppetserver="$PUPPET_SERVER_VERSION"-1"$UBUNTU_CODENAME" && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    gem install --no-rdoc --no-ri r10k

COPY puppetserver /etc/default/puppetserver
COPY logback.xml /etc/puppetlabs/puppetserver/
COPY request-logging.xml /etc/puppetlabs/puppetserver/
COPY puppetserver.conf /etc/puppetlabs/puppetserver/conf.d/

RUN puppet config set autosign true --section master && \
    cp -pr /etc/puppetlabs/puppet /var/tmp && \
    rm -rf /var/tmp/puppet/ssl

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
COPY docker-entrypoint.d /docker-entrypoint.d

EXPOSE 8140

ENTRYPOINT ["dumb-init", "/docker-entrypoint.sh"]
CMD ["foreground"]

COPY healthcheck.sh /
RUN chmod +x /healthcheck.sh
HEALTHCHECK --interval=10s --timeout=10s --retries=90 CMD ["/healthcheck.sh"]

COPY Dockerfile /
