# cache offline as much dependencies as possible
FROM maven:3.6.3-jdk-11-slim@sha256:68ce1cd457891f48d1e137c7d6a4493f60843e84c9e2634e3df1d3d5b381d36c as dependencies
WORKDIR /app
COPY market-core/pom.xml market-core/pom.xml
COPY market-rest/pom.xml market-rest/pom.xml
COPY market-web/pom.xml market-web/pom.xml
COPY market-coverage/pom.xml market-coverage/pom.xml
COPY pom.xml .
RUN mvn -B -e -C org.apache.maven.plugins:maven-dependency-plugin:3.1.2:go-offline

# build the project
FROM maven:3.6.3-jdk-11-slim@sha256:68ce1cd457891f48d1e137c7d6a4493f60843e84c9e2634e3df1d3d5b381d36c as build
WORKDIR /app
COPY --from=dependencies /root/.m2 /root/.m2
COPY --from=dependencies /app/ /app
COPY market-core/src /app/market-core/src
COPY market-rest/src /app/market-rest/src
COPY market-web/src /app/market-web/src
RUN mvn -B -e clean install -DskipTests=true

# create an image with the specified application