############################
# STEP 1 build executable binary
############################

FROM maven:3.8.4-jdk-8 as builder

WORKDIR /workspace

COPY src ./src
COPY pom.xml ./

RUN mvn


############################
# STEP 2 build a small image
############################
FROM openjdk:8
WORKDIR /
# Copy our static executable.