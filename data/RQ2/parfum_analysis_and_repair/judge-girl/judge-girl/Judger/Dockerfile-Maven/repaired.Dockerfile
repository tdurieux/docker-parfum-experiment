# The build context must be the project root

# Build Judger from Maven
FROM maven:3.6.3-openjdk-11-slim as maven-builder
COPY . /usr/src/app
WORKDIR /usr/src/app

# TODO to be efficient, the build should only target the Judger's module. It may be achieved by using the command: 'mvn package -DskipTests -pl Judger -am'
RUN mvn package -DskipTests


FROM adoptopenjdk/openjdk11:alpine-slim

# The quickest way to install GCC on Alpine Linux
RUN apk add --no-cache build-base

# Prepare judger.jar
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/target/judger-0.0.1-SNAPSHOT-jar-with-dependencies.jar judger.jar
CMD java -jar judger.jar



