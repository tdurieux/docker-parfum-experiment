# 1. Build
FROM maven:3.6-jdk-11 AS build
WORKDIR /app
COPY mtsj/ /app
RUN mvn clean install -Dmaven.test.skip=true

# 2. Deploy Java war
FROM adoptopenjdk/openjdk11:jre-11.0.4_11-alpine
WORKDIR /app
COPY --from=build /app/server/target/mythaistar-bootified.war /app/

HEALTHCHECK CMD [ curl --fail https://localhost:8081/mythaistar/services/rest/dishmanagement/v1/category/0/ || exit 1]
ENTRYPOINT ["java","-jar","/app/mythaistar-bootified.war"]
EXPOSE 8081