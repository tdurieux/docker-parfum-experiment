# Step : Test and package
FROM maven:3.8.4-openjdk-17 as builder
WORKDIR /build
COPY pom.xml .

COPY src/ /build/src/
COPY .git /build/.git/
RUN mvn -B -DskipTests package

# Step : Package image