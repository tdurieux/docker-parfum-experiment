FROM jboss/keycloak:14.0.0

ADD themes /opt/jboss/keycloak/themes
ADD providers /opt/jboss/keycloak/providers

ENTRYPOINT ["/opt/jboss/tools/docker-entrypoint.sh"]