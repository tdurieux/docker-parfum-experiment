# http://whitfin.io/speeding-up-maven-docker-builds/

FROM maven:3-jdk-11 as base

COPY ./pom.xml ./pom.xml
RUN mvn dependency:go-offline -B
COPY ./src ./src

FROM base as test
CMD ["mvn", "-Ptest", "test"]

FROM base as run
ARG PROFILE=dev
RUN mvn -P$PROFILE -Dmaven.test.skip=true package

# https://stackoverflow.com/questions/53375613/why-is-the-java-11-base-docker-image-so-large-openjdk11-jre-slim