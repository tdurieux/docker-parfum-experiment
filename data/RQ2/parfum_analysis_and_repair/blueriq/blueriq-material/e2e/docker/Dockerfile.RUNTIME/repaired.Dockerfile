FROM docker-internal.blueriq.com/tomcat9-jdk17:1.0
LABEL maintainer="support@blueriq.com"

ENV JAVA_OPTS="-Dspring.config.additional-location=file:///config/blueriq-runtime/ -Djava.security.egd=file:/dev/./urandom -Dlogging.file=runtime.log -Xmx768m"
EXPOSE 8080

COPY blueriq-runtime-application-*.war /usr/local/tomcat/webapps/runtime.war
ADD /config /config/blueriq-runtime/