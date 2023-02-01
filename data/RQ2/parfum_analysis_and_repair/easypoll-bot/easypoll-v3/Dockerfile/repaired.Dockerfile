FROM maven:3.6.0-jdk-11-slim AS build
WORKDIR /build

COPY src ./src
COPY pom.xml .

RUN mvn -f pom.xml clean package

FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /build/target/EasyPoll.jar /app/EasyPoll.jar

ENTRYPOINT ["java","-jar","/app/EasyPoll.jar"]