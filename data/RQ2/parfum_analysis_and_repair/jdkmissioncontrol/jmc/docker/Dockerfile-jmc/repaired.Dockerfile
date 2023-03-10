FROM openjdk:11.0.2-jdk-stretch AS builder

RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

WORKDIR /jmc
COPY core core/
COPY application application/
COPY configuration configuration/
COPY releng releng/
COPY pom.xml ./
RUN grep -rl localhost:8080 releng | xargs sed -i s/localhost:8080/p2:8080/
ENV MAVEN_OPTS="-Xmx1G"

CMD cd /jmc/core && mvn clean install && cd /jmc && mvn package && cp -a /jmc/target/* /target
