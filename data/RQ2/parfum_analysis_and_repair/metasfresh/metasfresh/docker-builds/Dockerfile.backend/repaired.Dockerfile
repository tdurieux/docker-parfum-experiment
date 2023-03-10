ARG REFNAME=local
FROM metasfresh/metas-mvn-common:$REFNAME as common

FROM alpine as poms

WORKDIR /backend
COPY backend . 
RUN find . -type f ! -name "pom.xml" -exec rm -r {} \;


FROM maven:3.8.4-jdk-8 as build

WORKDIR /backend

COPY --from=common /root/.m2 /root/.m2/
COPY --from=poms /backend .
RUN mvn de.qaware.maven:go-offline-maven-plugin:1.2.8:resolve-dependencies

COPY backend .
RUN mvn clean install -o -Dmaven.gitcommitid.skip=true -DskipTests