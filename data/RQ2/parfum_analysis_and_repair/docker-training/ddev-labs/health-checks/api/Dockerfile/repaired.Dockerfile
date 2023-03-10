FROM maven:3.5-jdk-8 AS build
COPY pom.xml .
RUN mvn --batch-mode dependency:resolve
COPY . .
RUN mvn --batch-mode package
RUN cp target/*jar target/app.jar

FROM openjdk:8-jre
RUN apt-get update -y && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
EXPOSE 8080
VOLUME /tmp
COPY --from=build target/app.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]


