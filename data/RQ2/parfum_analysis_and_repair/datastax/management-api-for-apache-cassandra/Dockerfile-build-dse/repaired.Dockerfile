FROM maven:3.6.3-jdk-8-slim

WORKDIR /build

COPY pom.xml ./
COPY management-api-agent-common/pom.xml ./management-api-agent-common/pom.xml
COPY management-api-agent-3.x/pom.xml ./management-api-agent-3.x/pom.xml
COPY management-api-agent-4.x/pom.xml ./management-api-agent-4.x/pom.xml
COPY management-api-agent-dse-6.8/pom.xml ./management-api-agent-dse-6.8/pom.xml
COPY management-api-common/pom.xml ./management-api-common/pom.xml
COPY management-api-server/pom.xml ./management-api-server/pom.xml

COPY settings.xml settings.xml /root/.m2/

COPY management-api-agent-common ./management-api-agent-common
COPY management-api-agent-3.x ./management-api-agent-3.x
COPY management-api-agent-4.x ./management-api-agent-4.x
COPY management-api-agent-dse-6.8 ./management-api-agent-dse-6.8
COPY management-api-common ./management-api-common
COPY management-api-server ./management-api-server
RUN mvn -ff -q clean package -DskipTests -P dse