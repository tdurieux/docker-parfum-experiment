FROM openjdk:8

RUN mkdir /twilio
WORKDIR /twilio

COPY src ./src
COPY pom.xml .

RUN apt-get update && apt-get install --no-install-recommends maven -y && rm -rf /var/lib/apt/lists/*;
RUN mvn clean install -Dmaven.test.skip=true
