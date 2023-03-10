FROM registry.access.redhat.com/ubi8/openjdk-11
ENV KEYCLOAK_VERSION=13.0.0
USER root
VOLUME /downloads
COPY ./distribution/server-x-dist/target/keycloak.x-${KEYCLOAK_VERSION}.tar.gz /downloads/
RUN mkdir -p /opt/keycloak
RUN chmod 0777 /opt/keycloak
RUN tar -zxvf /downloads/keycloak.x-${KEYCLOAK_VERSION}.tar.gz --strip 1 --directory /opt/keycloak && rm /downloads/keycloak.x-${KEYCLOAK_VERSION}.tar.gz
RUN /opt/keycloak/bin/kc.sh config --db=postgres --verbose --https-port=8443
EXPOSE 8443/tcp
USER 1000
ENTRYPOINT /opt/keycloak/bin/kc.sh
