FROM adoptopenjdk/openjdk8-openj9

USER root
RUN apt-get -qq update \
  && apt-get -qq --no-install-recommends install -y curl maven wget unzip xmlstarlet \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade -y \
  && apt-get -qq clean \
  && rm -rf /tmp/* /var/lib/apt/lists/*

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config

WORKDIR /project

# Build utility for version range processing
# Install parent pom
# Install maven wrapper in /project
RUN mkdir -p /mvn/repository \
 && /project/util/check_version build \
 && cd /project \
 && mvn -B -Dmaven.repo.local=/mvn/repository install dependency:go-offline -DskipTests \
 && mvn -B -N io.takari:maven:wrapper -Dmaven=$(mvn help:evaluate -Dexpression=maven.version -q -DforceStdout)

WORKDIR /project/user-app

ENV APPSODY_MOUNTS="~/.m2/repository:/mvn/repository;src:/project/user-app/src;pom.xml:/project/user-app/pom.xml"
ENV APPSODY_DEPS=

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/target
ENV APPSODY_WATCH_REGEX="^.*(.xml|.java|.properties)$"

ENV APPSODY_INSTALL="../validate.sh && mvn -B -Dmaven.repo.local=/mvn/repository install -DskipTests"

ENV APPSODY_RUN="mvn -B -Dmaven.repo.local=/mvn/repository liberty:run"
ENV APPSODY_RUN_ON_CHANGE="mvn -Dmaven.repo.local=/mvn/repository package -DskipTests"
ENV APPSODY_RUN_KILL=false

ENV APPSODY_DEBUG="mvn -B -Dmaven.repo.local=/mvn/repository liberty:debug"
ENV APPSODY_DEBUG_ON_CHANGE="mvn -Dmaven.repo.local=/mvn/repository package -DskipTests"
ENV APPSODY_DEBUG_KILL=false

ENV APPSODY_TEST="mvn -B -Dmaven.repo.local=/mvn/repository verify"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

ENV PORT=9080

EXPOSE 9080
EXPOSE 9443
EXPOSE 7777
