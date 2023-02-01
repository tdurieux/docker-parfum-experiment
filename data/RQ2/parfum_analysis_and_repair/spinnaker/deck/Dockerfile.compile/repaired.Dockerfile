FROM openjdk:11-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
  git && rm -rf /var/lib/apt/lists/*;

LABEL maintainer="sig-platform@spinnaker.io"
ENV GRADLE_USER_HOME /workspace/.gradle
ENV GRADLE_OPTS -Xmx2048m
CMD ./gradlew build --no-daemon -PskipTests
