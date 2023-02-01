# TAGS 6.0.2
FROM openjdk:8

ENV GOSU_VERSION 1.10
RUN set -ex; \
	\
	fetchDeps=' \
		wget \
	'; \
	apt-get update; \
	apt-get install -y --no-install-recommends $fetchDeps; \
	rm -rf /var/lib/apt/lists/*; \
	\
	dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')"; \
	wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
	\
	chmod +x /usr/local/bin/gosu; \
# verify that the binary works
	gosu nobody true

ENV ARTIFACTORY_USER_NAME=artifactory \
    ARTIFACTORY_USER_ID=1030 \
    ARTIFACTORY_HOME=/opt/jfrog/artifactory \
    ARTIFACTORY_DATA=/var/opt/jfrog/artifactory \
    RECOMMENDED_MAX_OPEN_FILES=32000 \
    MIN_MAX_OPEN_FILES=10000 \
    RECOMMENDED_MAX_OPEN_PROCESSES=1024

COPY entrypoint-artifactory.sh /

RUN mkdir /opt/jfrog && \
    wget -O /opt/jfrog/standalone.zip "https://api.bintray.com/content/jfrog/artifactory/jfrog-artifactory-oss-6.0.2.zip;bt_package=jfrog-artifactory-oss-zip" && \
    unzip -q /opt/jfrog/standalone.zip -d /opt/jfrog/ && \
    mv ${ARTIFACTORY_HOME}*/ ${ARTIFACTORY_HOME}/ && \
    rm -f /opt/jfrog/standalone.zip && \
    mv ${ARTIFACTORY_HOME}/etc ${ARTIFACTORY_HOME}/etc.orig/ && \
    rm -rf ${ARTIFACTORY_HOME}/logs && \
    ln -s ${ARTIFACTORY_DATA}/etc ${ARTIFACTORY_HOME}/etc && \
    ln -s ${ARTIFACTORY_DATA}/data ${ARTIFACTORY_HOME}/data && \
    ln -s ${ARTIFACTORY_DATA}/logs ${ARTIFACTORY_HOME}/logs && \
    ln -s ${ARTIFACTORY_DATA}/backup ${ARTIFACTORY_HOME}/backup && \
    ln -s ${ARTIFACTORY_DATA}/access ${ARTIFACTORY_HOME}/access && \
    chmod +x /entrypoint-artifactory.sh

# Download the DB driver into Tomcat's lib
RUN curl -L -o /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.41.jar https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

# Default mounts. Should be passed in `docker run` or in docker-compose
VOLUME ${ARTIFACTORY_DATA}

# Expose Tomcat's port
EXPOSE 8081

# Start the simple standalone mode of Artifactory
ENTRYPOINT ["/entrypoint-artifactory.sh"]
