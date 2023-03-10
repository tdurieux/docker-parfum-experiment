FROM maven:3.6.3-jdk-8-slim

WORKDIR /build

COPY pom.xml ./
COPY management-api-agent-common/pom.xml ./management-api-agent-common/pom.xml
COPY management-api-agent-3.x/pom.xml ./management-api-agent-3.x/pom.xml
COPY management-api-agent-4.x/pom.xml ./management-api-agent-4.x/pom.xml
COPY management-api-common/pom.xml ./management-api-common/pom.xml
COPY management-api-server/pom.xml ./management-api-server/pom.xml
# this duplicates work done in the next steps, but this should provide
# a solid cache layer that only gets reset on pom.xml changes
RUN mvn -q -ff -T 1C install && rm -rf target

COPY management-api-agent-common ./management-api-agent-common
COPY management-api-agent-3.x ./management-api-agent-3.x
COPY management-api-agent-4.x ./management-api-agent-4.x
COPY management-api-common ./management-api-common
COPY management-api-server ./management-api-server
RUN mvn -q -ff package -DskipTests