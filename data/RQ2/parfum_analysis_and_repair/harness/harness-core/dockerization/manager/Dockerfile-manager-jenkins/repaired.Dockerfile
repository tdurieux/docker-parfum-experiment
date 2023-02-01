# to be used when building in Jenkins
FROM harness/serverjre_8:191
RUN yum install -y hostname tar gzip net-tools traceroute nmap procps && rm -rf /var/cache/yum

# install yq - a YAML query command line tool
RUN curl -f -Lso yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
RUN chmod +x yq
RUN mv yq /usr/local/bin

# Add the capsule JAR and config.yml
COPY docker-image-files/rest-capsule.jar docker-image-files/AppServerAgent-4.5.0.23604.tar.gz keystore.jks docker-image-files/classpath_metadata.json docker-image-files/config.yml docker-image-files/hazelcast.xml docker-image-files/redisson-jcache.yaml /opt/harness/

COPY dockerization/manager/scripts /opt/harness

RUN chmod +x /opt/harness/*.sh
RUN mkdir /opt/harness/plugins

WORKDIR /opt/harness

CMD [ "./run.sh" ]
