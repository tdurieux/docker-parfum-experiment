FROM openjdk:8-jre-slim
VOLUME /tmp
COPY sanshan-auth.jar app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]