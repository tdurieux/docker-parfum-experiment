# This creates a jetty jre8 image containing obp-api-1.1.0.war. 
# It is a multi stage build, meaning a small-ish image is the end result. 

FROM alpine:latest  as repo
# Get repo fron github, store as stage 'repo'
RUN apk add --no-cache git
WORKDIR OBP-API-Explorer
RUN git clone https://github.com/OpenBankProject/API-Explorer.git

FROM maven:3-jdk-8 as maven
# Build the source using maven, source is copied from the 'repo' build.
COPY --from=repo /OBP-API-Explorer /usr/src
ADD api-explorer/API-Explorer.default.props /usr/src/API-Explorer/src/main/resources/props/default.props
RUN cp /usr/src/API-Explorer/pom.xml /tmp/pom.xml # For Packaging a local repository within the image
WORKDIR /usr/src/API-Explorer
RUN mvn package -DskipTests
#RUN mvn install -pl .,obp-commons
#RUN mvn install -DskipTests -pl obp-api

FROM openjdk:8-jre-alpine

# Add user 
RUN adduser -D obp

# Download jetty
RUN wget -O - https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.15.v20190215/jetty-distribution-9.4.15.v20190215.tar.gz | tar zx
RUN mv jetty-distribution-* jetty

# Copy API Explorer source code
# Copy build artifact (.war file) into jetty from 'maven' stage.
COPY --from=maven /usr/src/API-Explorer/target/API_Explorer-1.0.war jetty/webapps/ROOT.war

WORKDIR jetty
RUN chown -R  obp /jetty

# Switch to the obp user (non root)
USER obp

# Starts jetty