##### Build and Test stage
FROM maven:3.5.2-jdk-8-alpine AS build
WORKDIR /usr/src/app
ENV MVN_SETTINGS=/usr/share/maven/ref/settings-docker.xml

# 1. Only update dependencies when the pom.xml actually changed.
COPY ./demo-adapter-java/pom.xml .
RUN mvn -s $MVN_SETTINGS dependency:go-offline

# 2. Do the actual build.
COPY ./demo-adapter-java/src src
RUN mvn -s $MVN_SETTINGS package

##### Production stage