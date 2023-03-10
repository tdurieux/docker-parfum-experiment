FROM openjdk:8-jdk-alpine
VOLUME /tmp
ARG JAVA_OPTS
ENV JAVA_OPTS=$JAVA_OPTS
COPY {{ relativeJavaOutputPath }} {{ serviceName }}.jar
{{#each ports}}
EXPOSE {{ . }}
{{/each}}
ENTRYPOINT exec java $JAVA_OPTS -jar {{ serviceName }}.jar
# For Spring-Boot project, use the entrypoint below to reduce Tomcat startup time.
#ENTRYPOINT exec java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar {{ serviceName }}.jar