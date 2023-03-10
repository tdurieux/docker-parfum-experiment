FROM daggerok/glassfish:5.0-web
MAINTAINER Maksim Kostromin https://github.com/daggerok/docker

# check all apps healthy
HEALTHCHECK --interval=1s --timeout=3s --retries=30 \
 CMD wget -qS http://127.0.0.1:8080/rest-api/health \
  && wget -qS http://127.0.0.1:8080/ui/ \
  || exit 1

# deploy apps
COPY ./rest-api/target/*.war ./ui/target/*.war ${GLASSFISH_HOME}/glassfish/domains/domain1/autodeploy/