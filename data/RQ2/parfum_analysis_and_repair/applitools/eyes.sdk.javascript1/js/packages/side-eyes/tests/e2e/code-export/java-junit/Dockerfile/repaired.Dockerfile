FROM maven:latest
RUN mkdir /runner
WORKDIR /runner
COPY tests/pom.xml .
RUN mvn install