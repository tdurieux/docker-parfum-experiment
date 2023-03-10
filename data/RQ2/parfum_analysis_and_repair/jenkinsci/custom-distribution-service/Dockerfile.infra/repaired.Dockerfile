FROM maven:3.6.0-jdk-8-alpine AS MAVEN_BUILD

COPY pom.xml /build/
COPY src/ /build/src/
COPY config/ /build/config/

WORKDIR /build/

RUN mvn clean package spring-boot:repackage
RUN mv target/custom-distribution-service-*.jar custom-distribution-service.jar

FROM node:14.7.0-alpine AS NODE_BUILD

WORKDIR /build
COPY frontend/package* /build/
RUN npm install && npm cache clean --force;
COPY frontend/ /build/
ENV REACT_APP_API_URL /
RUN npm run build

FROM maven:3.6.0-jdk-8-alpine

LABEL maintainer="sladynnunes98@gmail.com"

RUN \
    addgroup -g 1000 -S appuser && \
    adduser -u 1000 -S appuser -G appuser && \
    mkdir /app && \
    chown -R appuser:appuser /app

USER appuser
WORKDIR /app

COPY --chown=appuser --from=MAVEN_BUILD /build/custom-distribution-service.jar /app/
COPY --chown=appuser --from=NODE_BUILD /build/build/ /app/public/

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/custom-distribution-service.jar"]
