FROM {{.stack.baseimage}}

# Ensure up to date / patched OS
COPY ./project/update.sh /update.sh
RUN  /update.sh

RUN groupadd --gid 1000 java_group \
 && useradd --uid 1000 --gid java_group --shell /bin/bash --create-home java_user \
 && mkdir -p /mvn/repository \
 && chown -R java_user:java_group /mvn

COPY ./LICENSE /licenses/
COPY --chown=java_user:java_group ./project /project
COPY --chown=java_user:java_group ./config /config
COPY ./mvn-stack-settings.xml /usr/share/maven/conf/settings.xml
COPY ./mvn-stack-settings.xml /project/mvn-stack-settings.xml

# Verify properties used to control versions match between this stack and official spring dependencies.
RUN /project/verify-property-versions.sh

USER java_user

# Build utility for version range processing
# Install maven wrapper in /project
RUN /project/util/check_version build \
 && cd /project \
 && mvn --no-transfer-progress -B -N io.takari:maven:wrapper -Dmaven=$(mvn help:evaluate -Dexpression=maven.version -q -DforceStdout)

WORKDIR /project/user-app

ENV APPSODY_USER_RUN_AS_LOCAL=true
ENV APPSODY_PROJECT_DIR="/project"

ENV APPSODY_MOUNTS=".:/project/user-app;~/.m2/repository:/mvn/repository"
ENV APPSODY_DEPS=

ENV APPSODY_WATCH_DIR="/project/user-app/src"
ENV APPSODY_WATCH_IGNORE_DIR=""
ENV APPSODY_WATCH_REGEX="(^.*\.java$)|(^.*\.properties$)|(^.*\.yaml$)|(^.*\.html$)|(^.*\.sql$)|(^.*\.js$)|(^.*\.properties$)"

ENV APPSODY_RUN="/project/java-spring-boot2-build.sh run"
ENV APPSODY_RUN_ON_CHANGE="/project/java-spring-boot2-build.sh recompile"
ENV APPSODY_RUN_KILL=false

ENV APPSODY_DEBUG="/project/java-spring-boot2-build.sh debug"
ENV APPSODY_DEBUG_ON_CHANGE="/project/java-spring-boot2-build.sh recompile"
ENV APPSODY_DEBUG_KILL=false

ENV APPSODY_TEST="/project/java-spring-boot2-build.sh test"
ENV APPSODY_TEST_ON_CHANGE=""
ENV APPSODY_TEST_KILL=true

ENV PORT=8080
ENV APPSODY_DEBUG_PORT=5005

EXPOSE 8080
EXPOSE 8443
EXPOSE 5005
EXPOSE 35729
ENTRYPOINT ["/project/java-spring-boot2-build.sh", "run"]