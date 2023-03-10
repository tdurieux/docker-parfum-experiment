FROM jetty:10.0.6-jdk17

LABEL maintainer="atzeinicola@gmail.com"

ADD xyz.balzaclang.balzac.web/target/*.war /var/lib/jetty/webapps/balzac.war

EXPOSE 8080

HEALTHCHECK CMD curl --fail http://localhost:8080/balzac/version || exit 1

ENV JAVA_OPTIONS "--add-opens java.base/java.lang=ALL-UNNAMED"

CMD ["java","-jar","/usr/local/jetty/start.jar"]