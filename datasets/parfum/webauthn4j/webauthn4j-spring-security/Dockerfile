FROM openjdk:8-jdk AS build-env

LABEL maintainer="Yoshikazu Nojima <mail@ynojima.net>"

ADD . /workspace
WORKDIR /workspace
RUN ./gradlew build -x test


FROM openjdk:8-jre

LABEL maintainer="Yoshikazu Nojima <mail@ynojima.net>"

COPY --from=build-env /workspace/samples/spa/build/libs/webauthn4j-spring-security-sample-spa.jar /opt/webauthn4j-spring-security/webauthn4j-spring-security-sample-spa.jar

WORKDIR /opt/webauthn4j-spring-security
CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-jar", "/opt/webauthn4j-spring-security/webauthn4j-spring-security-sample-spa.jar"]

EXPOSE 8080
