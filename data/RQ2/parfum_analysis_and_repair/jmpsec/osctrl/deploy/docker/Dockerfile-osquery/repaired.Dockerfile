ARG OSCTRL_VERSION
FROM jmpsec/osctrl-cli:v${OSCTRL_VERSION}

ARG OSQUERY_VERSION=5.2.2

USER root

# Install Osquery
RUN apt-get update -y -qq && apt-get install --no-install-recommends -y curl host && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://pkg.osquery.io/deb/osquery_${OSQUERY_VERSION}-1.linux_amd64.deb \
    --output /tmp/osquery_${OSQUERY_VERSION}-1.linux_amd64.deb
RUN dpkg -i /tmp/osquery_${OSQUERY_VERSION}-1.linux_amd64.deb


# Entrypoint
COPY deploy/docker/conf/osquery/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]