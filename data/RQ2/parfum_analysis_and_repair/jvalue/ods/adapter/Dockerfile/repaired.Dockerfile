#-------------------------------------------------------#
# First stage: image to build and test Java application #
#-------------------------------------------------------#
# The gradle version here should match the gradle version in gradle/wrapper/gradle-wrapper.properties
FROM gradle:6.7-jdk15-openj9 as builder

WORKDIR /builder

# Copy gradle files
COPY *.gradle /builder/

# Required when downloading the dependencies:
COPY src/main/resources/application.properties /builder/src/main/resources/application.properties

# Download dependencies
RUN gradle dependencies --refresh-dependencies --info

# Copy remaining source files
COPY src /builder/src

# Build project and run unit tests
RUN gradle assemble
RUN gradle test

#-------------------------------------------------------#
# Second stage: image to run Java application           #
#-------------------------------------------------------#
FROM adoptopenjdk/openjdk15-openj9:alpine-slim

RUN mkdir /app
WORKDIR /app

ENV SPRING_PROFILES_ACTIVE prod

# Pull the dist files from the builder container
COPY --from=builder /builder/build/libs/* app.jar

# Run app