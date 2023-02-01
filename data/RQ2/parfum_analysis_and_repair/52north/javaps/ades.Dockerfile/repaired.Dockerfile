# ---- Clone third-party dependencies from GitHub ----
FROM alpine/git as clone
WORKDIR /app

#clone javaPS
RUN git clone https://github.com/52North/javaPS.git \
	&& git -C ./javaPS checkout develop && cd ./javaPS && git status

#clone javaPS docker backend
RUN git clone https://github.com/52North/javaps-docker-backend.git \
	&& git -C ./javaps-docker-backend checkout tags/v1.1.0 && cd ./javaps-docker-backend && git status


FROM maven:3-jdk-8-alpine AS BUILD

RUN apk add --no-cache git

#build javaPS (without webapp)
COPY --from=clone /app/javaPS /app/javaPS

RUN cd /app/javaPS && mvn --batch-mode --errors --fail-fast \
  --define maven.javadoc.skip=true \
  --define skipTests=true install -pl "!webapp"

#build javaPS docker backend
COPY --from=clone /app/javaps-docker-backend /app/javaps-docker-backend

RUN cd /app/javaps-docker-backend && mvn clean install -DskipTests=true

#build javaPS webapp


RUN mv -f /app/javaPS/etc/ades-webapp-pom.xml /app/javaPS/webapp/pom.xml

RUN cd /app/javaPS/webapp && mvn --batch-mode --errors --fail-fast \
  --define maven.javadoc.skip=true \
  --define skipTests=true install


FROM jetty:jre8

ENV JAVAPS_ROOT ${JETTY_BASE}/webapps/ROOT
ENV JAVAPS_TMP ${JAVAPS_ROOT}/WEB-INF/tmp
ENV JAVAPS_CONFIG ${JAVAPS_ROOT}/WEB-INF/config
ENV JAVAPS_LIB ${JAVAPS_ROOT}/WEB-INF/lib


COPY --from=BUILD /app/javaPS/webapp/target/javaPS-webapp/ /var/lib/jetty/webapps/ROOT
COPY --from=BUILD /app/javaPS/etc/docker-log4j2.xml /var/lib/jetty/webapps/ROOT/WEB-INF/config/log4j2.xml
copy --from=BUILD /app/javaPS/etc/docker-configuration.json /var/lib/jetty/webapps/ROOT/WEB-INF/config/configuration.json

USER root
RUN set -ex \
 && apt-get update \
 && apt-get install -y --no-install-recommends jq \
 && rm -rf /var/lib/apt/lists/* \
 && wget -q -P /usr/local/bin https://raw.githubusercontent.com/52North/arctic-sea/master/etc/faroe-entrypoint.sh \
 && chmod +x /usr/local/bin/faroe-entrypoint.sh \
 && ln -sf ${JAVAPS_CONFIG}/log4j2.xml ${JAVAPS_ROOT}/WEB-INF/classes/log4j2.xml \
 && mkdir -p ${JAVAPS_TMP}\
 && chown -R jetty:jetty ${JAVAPS_ROOT}
USER jetty

VOLUME /var/lib/jetty/webapps/ROOT/WEB-INF/tmp
VOLUME /var/lib/jetty/webapps/ROOT/WEB-INF/config

# use the info endpoint, the capabilities produces a lot of log spam