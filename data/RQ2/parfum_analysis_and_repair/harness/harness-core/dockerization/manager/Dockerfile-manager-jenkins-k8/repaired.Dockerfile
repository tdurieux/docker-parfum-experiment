# to be used when building in Jenkins
FROM harness/serverjre_8:191
RUN yum install -y hostname tar gzip net-tools traceroute nmap procps && rm -rf /var/cache/yum

# install yq - a YAML query command line tool
RUN curl -f -Lso yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
RUN chmod +x yq
RUN mv yq /usr/local/bin

# Add the capsule JAR and config.yml
COPY rest-capsule.jar newrelic.yml keystore.jks classpath_metadata.json config.yml hazelcast.xml redisson-jcache.yaml /opt/harness/

COPY scripts /opt/harness

RUN chmod +x /opt/harness/*.sh
RUN mkdir /opt/harness/plugins

WORKDIR /opt/harness

CMD [ "./run.sh" ]
