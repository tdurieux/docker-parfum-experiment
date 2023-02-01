FROM harness/java-docker-base:smp_jdk11

COPY --chown=65534:65534 keystore.jks /opt/harness/
COPY --chown=65534:65534 redisson-jcache.yaml /opt/harness/
COPY --chown=65534:65534 ci-manager-config.yml /opt/harness/
COPY --chown=65534:65534 classpath_metadata.json /opt/harness/
COPY --chown=65534:65534 ci-manager-capsule.jar /opt/harness/
COPY --chown=65534:65534 scripts /opt/harness/

RUN chmod 500 /opt/harness/*.sh

CMD [ "./run.sh" ]