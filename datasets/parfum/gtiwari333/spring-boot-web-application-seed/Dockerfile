FROM adoptopenjdk/openjdk11
VOLUME /tmp
VOLUME /X/attachments
COPY core/target/*.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
