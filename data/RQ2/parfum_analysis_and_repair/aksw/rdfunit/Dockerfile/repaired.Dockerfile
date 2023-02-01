# Image to build the jar
FROM maven:3-jdk-8 as build

COPY . /app
WORKDIR /app

RUN mvn -pl rdfunit-validate -am clean package -P cli-standalone -DskipTests=true


# Final image to run the jar