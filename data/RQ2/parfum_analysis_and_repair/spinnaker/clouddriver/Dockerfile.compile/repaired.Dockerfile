FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -y \
    openjdk-11-jdk \
 && rm -rf /var/lib/apt/lists/*
LABEL maintainer="sig-platform@spinnaker.io"
ENV GRADLE_USER_HOME /workspace/.gradle
ENV GRADLE_OPTS "-Xmx4g -Xms2g"
CMD ./gradlew --no-daemon clouddriver-web:installDist -x test
