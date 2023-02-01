FROM anapsix/alpine-java
VOLUME /tmp
ADD target/appsensor-ws-rest-server-boot-0.0.1-SNAPSHOT.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
