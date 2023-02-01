# Docker multi-stage build

# 1. Building the App with Maven
FROM maven:3-jdk-11

ADD ./server/authentication-service /authentication_service_staging

WORKDIR /authentication_service_staging

# Just echo so we can see, if everything is there
RUN ls -l

# Run Maven build
RUN mvn clean install -DskipTests

# 2. Just using the build artifact and then removing the build-container
FROM openjdk:11-jdk

VOLUME /tmp

# Add Spring Boot authentication-service.jar to Container
COPY --from=0 /authentication_service_staging/target/authentication-service.jar authentication-service.jar

# Fire up our Spring Boot app by default