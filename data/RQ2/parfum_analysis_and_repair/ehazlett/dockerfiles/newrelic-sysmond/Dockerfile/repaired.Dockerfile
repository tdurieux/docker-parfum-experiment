FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y curl && \
    curl -f -sSL https://download.newrelic.com/debian/dists/newrelic/non-free/binary-amd64/newrelic-sysmond_2.3.0.132_amd64.deb -o /tmp/newrelic.deb && \
    dpkg -i /tmp/newrelic.deb && \
    apt-get -f -y install && \
    rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*;
COPY run.sh /bin/run
CMD ["/bin/run"]
