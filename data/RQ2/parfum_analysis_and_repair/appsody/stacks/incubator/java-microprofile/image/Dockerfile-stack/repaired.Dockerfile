FROM adoptopenjdk/openjdk8-openj9

USER root
RUN apt-get -qq update \
  && apt-get -qq --no-install-recommends install -y curl maven xmlstarlet wget \
  && DEBIAN_FRONTEND=noninteractive apt-get -qq upgrade -y \
  && apt-get -qq clean \
  && rm -rf /tmp/* /var/lib/apt/lists/*

COPY ./LICENSE /licenses/
COPY ./project /project
COPY ./config /config

RUN  /project/util/check_version build

WORKDIR /project/
RUN mkdir -p /mvn/repository
RUN mvn -B -Dmaven.repo.local=/mvn/repository -N io.takari:maven:wrapper -Dmaven=$(mvn help:evaluate -Dexpression=maven.version -q -DforceStdout)
RUN mvn -B -Dmaven.repo.local=/mvn/repository install dependency:go-offline -DskipTests
RUN mvn -Dmaven.repo.local=/mvn/repository install dependency:go-offline -DskipTests -f pom-dev.xml

WORKDIR /project/user-app

ENV APPSODY_MOUNTS="~/.m2/repository:/mvn/repository;src:/project/user-app/src;pom.xml:/project/user-app/pom.xml"
ENV APPSODY_DEPS=

ENV APPSODY_WATCH_DIR=/project/user-app
ENV APPSODY_WATCH_IGNORE_DIR=/project/user-app/target
ENV APPSODY_WATCH_REGEX="^.*(.xml|.java|.properties)$"

ENV APPSODY_INSTALL="../validate.sh && mvn -B -Dmaven.repo.local=/mvn/repository install -DskipTests && /project/install-dev-deps.sh"

ENV APPSODY_RUN="JVM_ARGS='-javaagent:resources/javametrics-agent.jar' mvn -B -Dmaven.repo.local=/mvn/repository liberty:run"
ENV APPSODY_RUN_ON_CHANGE="JVM_ARGS='-javaagent:resources/javametrics-agent.jar' mvn -Dmaven.repo.local=/mvn/repository package -DskipTests"
ENV APPSODY_RUN_KILL=false

ENV APPSODY_DEBUG="JVM_ARGS='-javaagent:resources/javametrics-agent.jar' mvn -B -Dmaven.repo.local=/mvn/repository liberty:debug"
ENV APPSODY_DEBUG_ON_CHANGE="JVM_ARGS='-javaagent:resources/javametrics-agent.jar' mvn -Dmaven.repo.local=/mvn/repository package -DskipTests"
ENV APPSODY_DEBUG_KILL=false

ENV APPSODY_TEST="mvn -B -Dmaven.repo.local=/mvn/repository verify"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=false

ENV PORT=9080

EXPOSE 9080
EXPOSE 9443
EXPOSE 7777
