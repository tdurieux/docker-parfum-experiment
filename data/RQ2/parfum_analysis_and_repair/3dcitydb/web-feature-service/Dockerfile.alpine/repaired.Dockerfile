# 3DCityDB Web Feature Service Dockerfile  - Alpine ###########################
#   Official website    https://www.3dcitydb.org
#   GitHub              https://github.com/3dcitydb/web-feature-service
###############################################################################

# Fetch & build stage #########################################################
# ARGS
ARG BUILDER_IMAGE_TAG='17-jdk-slim'
ARG RUNTIME_IMAGE_TAG='9-alpine'

# Base image
FROM openjdk:${BUILDER_IMAGE_TAG} AS builder

ARG DEFAULT_CONFIG='default-config.xml'

# Copy source code
WORKDIR /build
COPY . /build

# Copy default config
COPY resources/docker/${DEFAULT_CONFIG} src/main/webapp/WEB-INF/config.xml

# Build
RUN chmod u+x ./gradlew && ./gradlew installDist

# Runtime stage ###############################################################
# Base image
FROM tomcat:${RUNTIME_IMAGE_TAG} AS runtime

ARG TOMCAT_USER='tomcat'
ARG TOMCAT_GROUP='tomcat'

# Run as non-root user user
RUN addgroup -g 1000 -S ${TOMCAT_GROUP} && \
    adduser -u 1000 -G ${TOMCAT_USER} -h /citydb-wfs -S ${TOMCAT_USER} && \
    chown -R 1000:1000 ${CATALINA_HOME}

# Copy WAR to webapps folder
COPY --from=builder --chown=1000:1000 /build/build/install/3DCityDB-Web-Feature-Service/citydb-wfs.war \
     ${CATALINA_HOME}/webapps/ROOT.war

COPY --chown=1000:1000 resources/docker/citydb-wfs-entrypoint.sh /usr/local/bin/

# Delete existing ROOT context and set permissions
RUN rm -rf ${CATALINA_HOME}/webapps/ROOT && \
    chmod a+x /usr/local/bin/citydb-wfs-entrypoint.sh

WORKDIR /citydb-wfs
USER 1000
EXPOSE 8080

ENTRYPOINT ["citydb-wfs-entrypoint.sh"]
CMD ["catalina.sh","run"]

# Labels ######################################################################