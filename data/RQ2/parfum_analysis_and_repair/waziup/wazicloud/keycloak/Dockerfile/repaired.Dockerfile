#FROM jboss/keycloak:3.4.3.Final
FROM jboss/keycloak:4.4.0.Final
#FROM pedroigor/keycloak:jdk8

# Copy Waziup theme
RUN mkdir -p /opt/jboss/keycloak/themes/waziup/
COPY waziup /opt/jboss/keycloak/themes/waziup/

#Setup the realm