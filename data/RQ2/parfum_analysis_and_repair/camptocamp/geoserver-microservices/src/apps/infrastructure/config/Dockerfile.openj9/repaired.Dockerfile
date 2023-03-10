FROM ibm-semeru-runtimes:open-17-jre as builder
ARG JAR_FILE=target/gs-cloud-*-bin.jar

COPY ${JAR_FILE} application.jar

RUN java -Djarmode=layertools -jar application.jar extract

##########
FROM ibm-semeru-runtimes:open-17-jre

LABEL maintainer="GeoServer PSC <geoserver-users@lists.sourceforge.net>"

RUN mkdir -p /opt/app/bin

# Where jgit will try to create a .config directory
ENV XDG_CONFIG_HOME=/tmp

WORKDIR /opt/app/bin
ENV JAVA_OPTS=
EXPOSE 8080

COPY --from=builder dependencies/ ./
COPY --from=builder snapshot-dependencies/ ./
COPY --from=builder spring-boot-loader/ ./
COPY --from=builder application/ ./

HEALTHCHECK \
--interval=10s \
--timeout=5s \
--start-period=30s \
--retries=5 \
CMD curl -f -s -o /dev/null localhost:8081/actuator/health || exit 1

CMD exec env USER_ID="$(id -u)" USER_GID="$(id -g)" java $JAVA_OPTS org.springframework.boot.loader.JarLauncher