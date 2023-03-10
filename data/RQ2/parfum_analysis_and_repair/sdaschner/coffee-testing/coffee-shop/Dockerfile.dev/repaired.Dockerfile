FROM adoptopenjdk/openjdk16-openj9:x86_64-alpine-jre-16.0.1_9_openj9-0.26.0
RUN apk add --no-cache curl

ENV QUARKUS_LAUNCH_DEVMODE=true \
    JAVA_ENABLE_DEBUG=true

COPY target/quarkus-app/lib/ /deployments/lib/
COPY target/quarkus-app/*.jar /deployments/
COPY target/quarkus-app/quarkus/ /deployments/quarkus/
COPY target/quarkus-app/app/ /deployments/app/

CMD ["java", "-jar", "-Dquarkus.http.host=0.0.0.0", "-Djava.util.logging.manager=org.jboss.logmanager.LogManager", "-Dquarkus.package.type=mutable-jar", "-Dquarkus.live-reload.password=123", "/deployments/quarkus-run.jar"]