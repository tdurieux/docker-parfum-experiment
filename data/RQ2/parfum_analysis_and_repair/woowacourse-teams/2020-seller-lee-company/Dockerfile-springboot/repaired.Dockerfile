FROM openjdk:8-alpine

VOLUME /tmp

EXPOSE 8080

ARG JAR_FILE=back/api/build/libs/api-0.0.1-SNAPSHOT.jar

ADD ${JAR_FILE} seller-lee-springboot.jar

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-Dspring.profiles.active=dev","-jar","/seller-lee-springboot.jar"]