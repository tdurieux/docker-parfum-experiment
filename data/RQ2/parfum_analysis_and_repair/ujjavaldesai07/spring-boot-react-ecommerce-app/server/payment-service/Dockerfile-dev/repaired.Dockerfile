# Docker multi-stage build

# 1. Building the App with Maven
FROM maven:3-jdk-11

ADD ./server/payment-service /payment_service_staging

WORKDIR /payment_service_staging

# Just echo so we can see, if everything is there
RUN ls -l

# Run Maven build
RUN mvn clean install -DskipTests

# 2. Just using the build artifact and then removing the build-container
FROM openjdk:11-jdk

VOLUME /tmp

# Add Spring Boot payment-service.jar to Container
COPY --from=0 /payment_service_staging/target/payment-service.jar payment-service.jar

# Fire up our Spring Boot app by default