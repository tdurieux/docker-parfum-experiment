FROM java:8-alpine
VOLUME /tmp
ARG JAR_FILE
ADD ./target/${JAR_FILE} /images.jar
RUN sh -c 'touch /images.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/images.jar"]
