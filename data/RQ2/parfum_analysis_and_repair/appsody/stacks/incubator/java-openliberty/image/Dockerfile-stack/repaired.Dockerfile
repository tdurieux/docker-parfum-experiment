FROM kabanero/ubi8-maven:0.10.3

LABEL vendor="Open Liberty" \
    name="{{.stack.id}}" \
    version="{{.stack.version}}" \
    summary="{{.stack.name}}" \
    description="{{.stack.description}}"
    
RUN  groupadd --gid 1000 java_group \
  && useradd --uid 1000 --gid java_group --shell /bin/bash --create-home java_user \
  && mkdir -p /mvn/repository \
  && chown -R java_user:java_group /mvn \
  && mkdir -p /opt/ol \
  && chown -R java_user:java_group /opt


COPY ./LICENSE /licenses/
COPY --chown=java_user:java_group ./project /project
COPY --chown=java_user:java_group ./config /config
COPY ./mvn-stack-settings.xml /usr/share/maven/conf/settings.xml


USER java_user

RUN  /project/util/check_version build

WORKDIR /project/

RUN mkdir -p /mvn/repository
# Let's see the command we're hiding within the next line
RUN mvn -e help:evaluate -Dexpression=maven.version -DforceStdout
RUN mvn -B  -N io.takari:maven:wrapper -Dmaven=$(mvn help:evaluate -Dexpression=maven.version -q -DforceStdout)
RUN mvn -B -Pstack-image-package liberty:install-server install dependency:go-offline
RUN chmod -R 777 /opt/ol && chmod -R 777 /mvn/repository


WORKDIR /project/user-app

ENV APPSODY_MOUNTS="~/.m2/repository:/mvn/repository;.:/project/user-app"

ENV APPSODY_USER_RUN_AS_LOCAL=true

# Allow validate to distinguish build via APPSODY_DEV_MODE
ENV APPSODY_PREP="/project/run-stack.sh prep"

ENV APPSODY_RUN="/project/run-stack.sh run"

ENV APPSODY_DEBUG="/project/run-stack.sh debug"

ENV APPSODY_TEST="/project/run-stack.sh test"

ENV PORT=9080
ENV APPSODY_DEBUG_PORT=7777

EXPOSE 9080
EXPOSE 9443
EXPOSE 7777