FROM registry.access.redhat.com/ubi7/ubi:latest
### setup nodejs & logagent
RUN yum install curl
RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash -
RUN yum install -y nodejs
RUN npm install -g @sematext/logagent

MAINTAINER Sematext Group Inc. <redhat@sematext.com>
### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="sematext/logagent" \
      vendor="Sematext Group Inc." \
      version="2.0" \
      release="2" \
      summary="Sematext Logagent" \
      description="Sematext Logagent is a modern, open-source, container-native log collection agent for Docker. It runs as a tiny container on every Docker host and provides automatic collection and processing of Docker Logs for all cluster nodes and all auto-discovered containers. It works with Open Shift/Kubernetes or any other platform supporting Docker containers." \
### Required labels above - recommended below
      url="https://sematext.com/docker" \
      run='docker run --privileged --name ${NAME} -e LOGS_TOKEN=${LOGS_TOKEN} -v /var/run/docker.sock:/var/run/docker.sock ${IMAGE}' \
      io.k8s.description="Sematext Logagent collects container logs" \
      io.k8s.display-name="Sematext Logagent" \
      io.openshift.tags="sematext,logging,log management,container logs"


COPY ./LICENSE /licenses/LICENSE
COPY ./help.1 /help.1

ENV APP_ROOT=/opt/sematext 
ENV USER_NAME=default \
    USER_UID=10001 
RUN mkdir -p $APP_ROOT/licenses

COPY ./run.sh $APP_ROOT/bin/run.sh 

ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p /logs-buffer 

# Setup tini https://github.com/krallin/tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini ${APP_ROOT}/bin/tini

### Setup user for build execution and application runtime
RUN chmod -R ug+x ${APP_ROOT}/bin && sync && \
    useradd -l -u ${USER_UID} -r -g 0 -d ${APP_ROOT} -s /sbin/nologin -c "${USER_NAME} user" ${USER_NAME} && \
    chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} && chown -R ${USER_UID}:0 /logs-buffer && \
    chown -R ${USER_UID}:0 ${APP_ROOT}

### Containers should NOT run as root as a good practice
USER 10001
HEALTHCHECK --interval=1m --timeout=10s CMD ps -ef | grep -v grep | grep -e logagent || exit 1

ENTRYPOINT ["/opt/sematext/bin/tini", "--"]
CMD ["/opt/sematext/bin/run.sh"]