# Docker multi-stage build

# 1. Building the App with Maven
FROM maven:3-jdk-11

ADD . /search_suggestion_service_staging

WORKDIR /search_suggestion_service_staging

# Just echo so we can see, if everything is there
RUN ls -l

# Run Maven build
RUN mvn clean install -DskipTests

# 2. Just using the build artifact and then removing the build-container
FROM openjdk:11-jdk

VOLUME /tmp

# Add Spring Boot search-suggestion-service.jar to Container
COPY --from=0 /search_suggestion_service_staging/target/search-suggestion-service.jar search-suggestion-service.jar

# Fire up our Spring Boot app by default