# First stage: build environment
FROM maven:3.5.0-jdk-8-alpine AS builder

# To resolve dependencies first without re-download everytime
ADD ./pom.xml pom.xml
# By default mvn use '~/.m2' which could be cleaned up, change to use './.m2'
RUN mvn install -Dmaven.repo.local=./.m2

ADD ./src src/
# package jar
RUN mvn install -Dmaven.test.skip=true -Dmaven.repo.local=./.m2

# Second stage: runtime environment
From openjdk:15

# copy jar from the first stage
COPY --from=builder target/{{ .ArtifactName }}.jar {{ .ArtifactName }}.jar

# MY_CPU_LIMIT could be imported via downward API automatically in Kubernetes Deployment.