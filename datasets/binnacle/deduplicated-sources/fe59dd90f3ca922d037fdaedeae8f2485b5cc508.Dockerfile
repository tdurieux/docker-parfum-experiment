FROM registry.access.redhat.com/rhel-atomic
MAINTAINER Sematext Group Inc. <redhat@sematext.com>
### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="sematext/sematext-agent-docker" \
      vendor="Sematext Group Inc." \
      version="1.31.31" \
      release="2" \
      summary="Sematext Docker Agent" \
      description="Sematext Agent is a modern, open-source, container-native monitoring and log collection agent for Docker. It runs as a tiny container on every Docker host and provides automatic collection and processing of Docker Metrics, Events and Logs for all cluster nodes and all auto-discovered containers. It works with Open Shift/Kubernetes or any other platform supporting Docker containers." \
### Required labels above - recommended below
      url="https://sematext.com/docker" \
      run='docker run --privileged --name ${NAME} -e LOGSENE_TOKEN=${LOGSENE_TOKEN} -e ${SPM_TOKEN} -v /var/run/docker.sock:/var/run/docker.sock ${IMAGE}' \
      io.k8s.description="Sematext Docker Agent collects metrics, docker events and container logs" \
      io.k8s.display-name="Sematext Docker Agent" \
      io.openshift.tags="sematext,monitoring,logging"

RUN mkdir /licenses
COPY ./LICENSE /licenses/LICENSE
COPY ./help.1 /help.1
ENV PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:/opt/rh/rh-nodejs6/root/usr/bin:/opt/rh/rh-nodejs6/root/usr/lib:$PATH
ENV LD_LIBRARY_PATH=/opt/rh/rh-nodejs6/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/spm \
    USER_NAME=default \
    USER_UID=10001

# Setup Node.js 
RUN microdnf install git  --enablerepo=rhel-7-server-rpms && microdnf install rh-nodejs6 rh-nodejs6-npm --enablerepo=rhel-server-rhscl-7-rpms --enablerepo=rhel-7-server-rpms && microdnf clean all
RUN microdnf update 

### Setup user for build execution and application runtime
ENV APP_ROOT=/opt/spm \
    USER_NAME=default \
    USER_UID=10001

COPY . ${APP_ROOT}
COPY ./Dockerfile.rhel-atomic /Dockerfile
WORKDIR ${APP_ROOT}

RUN npm install -g 

ENV APP_HOME=${APP_ROOT}/src  PATH=$PATH:${APP_ROOT}/bin
RUN mkdir -p ${APP_ROOT}/spmlogs && mkdir -p /logsene-log-buffer && mkdir -p /opt/spm
# Setup tini https://github.com/krallin/tini
ENV TINI_VERSION v0.15.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini ${APP_ROOT}/bin/tini
### Setup user for build execution and application runtime
RUN chmod -R ug+x ${APP_ROOT}/bin && sync && \
    useradd -l -u ${USER_UID} -r -g 0 -d ${APP_ROOT} -s /sbin/nologin -c "${USER_NAME} user" ${USER_NAME} && \
    chown -R ${USER_UID}:0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} && chown -R ${USER_UID}:0 /logsene-log-buffer && chown -R ${USER_UID}:0 /opt/spm

### Containers should NOT run as root as a good practice
USER 10001

EXPOSE 9000
VOLUME ${APP_ROOT}/spmlogs

ENTRYPOINT ["/opt/spm/bin/tini", "--"]
CMD ["/opt/spm/run.sh"]

