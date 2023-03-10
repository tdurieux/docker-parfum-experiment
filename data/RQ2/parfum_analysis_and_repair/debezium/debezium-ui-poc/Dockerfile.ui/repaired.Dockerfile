FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3 AS builder

ARG JAVA_PACKAGE=java-11-openjdk-headless

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'
ENV JAVA_HOME="/usr/lib/jvm/jre-11"
ENV NPM_CONFIG_CACHE="/.cache/npm"

RUN microdnf install ca-certificates ${JAVA_PACKAGE} java-11-openjdk-devel git \
    && microdnf update \
    && microdnf clean all \
    && mkdir -p /javabuild/backend \
    && mkdir -p /javabuild/ui \
    && chown -R 1001 /javabuild \
    && chmod -R "g+rwX" /javabuild \
    && chown -R 1001:root /javabuild \
    && mkdir -p /.cache \
    && chown -R 1001 /.cache \
    && chmod -R "g+rwX" /.cache \
    && chown -R 1001:root /.cache \
    && echo "securerandom.source=file:/dev/urandom" >> /etc/alternatives/jre/lib/security/java.security

USER 1001

COPY --chown=1001:root mvnw /javabuild/mvnw
COPY --chown=1001:root .mvn/ /javabuild/.mvn/
COPY --chown=1001:root pom.xml /javabuild/
COPY --chown=1001:root backend/pom.xml /javabuild/backend/pom.xml
COPY --chown=1001:root ui/pom.xml /javabuild/ui/pom.xml

WORKDIR /javabuild

RUN ./mvnw clean dependency:go-offline -am -pl ui -Dmaven.wagon.http.pool=false -Dmaven.wagon.httpconnectionManager.ttlSeconds=120

COPY --chown=1001:root ui/ /javabuild/ui/
COPY --chown=1001:root .git/ /javabuild/.git/

RUN ./mvnw -am -pl ui package -Dquarkus.package.type=fast-jar -Dmaven.wagon.http.pool=false -Dmaven.wagon.httpconnectionManager.ttlSeconds=120

FROM nginxinc/nginx-unprivileged:1

ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en'

COPY --from=builder --chown=root:root /javabuild/ui/target/classes/ /usr/share/nginx/html/
COPY --chown=root:root deployment/dbzui-config.sh /docker-entrypoint.d/dbzui-config.sh
COPY --chown=nginx:root ui/config/config.js /usr/share/nginx/html/config.js