###############################################################################
#
#IMAGE:   Jenkins(Alpine)
#VERSION: 2.190.2
#BASE:    Jenkins LTS Version
#INTEGRATION:
#         Jenkins Slave: 3.28
#         tini         : 0.18.0
#         maven        : 3.6.2
#         sonar-scanner: 3.2.0.1227
#         kubectl      : 1.10.12
#         docker       : 18.09.0
#         svn          : 1.10.2
#
###############################################################################
FROM openjdk:8-jdk-alpine

###############################################################################
#MAINTAINER
###############################################################################
MAINTAINER LiuMiao <liumiaocn@outlook.com>

###############################################################################
#ARG Setting
###############################################################################
ARG http_port=8080
ARG agent_port=50000
ARG TINI_VERSION=0.18.0
ARG TINI_SHA=eadb9d6e2dc960655481d78a92d2c8bc021861045987ccd3e27c7eae5af0cf33
ARG JENKINS_HOME="/data/jenkins"
ARG JENKINS_SLAVE_VER="3.28"
ARG JENKINS_SLAVE_AGENT_PORT=${agent_port}
ARG JENKINS_VERSION=${JENKINS_VERSION:-2.190.2}
ARG JENKINS_SHA=47620a00004af5634e45904149897fe4a36b0463ec691bfabc2086779f90f127
ARG JENKINS_URL=http://mirrors.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war
ARG COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log
ARG MAVEN_HOME="/usr/local/share/maven"
ARG MAVEN_VER="3.6.2"
ARG SONAR_HOME="/usr/local/share/sonar"
ARG SONAR_SCANNER_VER="3.2.0.1227"
ARG KUBECTL_VER="1.10.12"
ARG DOCKER_VERSION=18.09.0

###############################################################################
#ENV Setting
###############################################################################
ENV JENKINS_HOME ${JENKINS_HOME}
ENV JENKINS_MODE ${JENKINS_MODE}
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV JENKINS_ADMIN_ID=${JENKINS_ADMIN_ID:-root}
ENV JENKINS_ADMIN_PW=${JENKINS_ADMIN_PW:-hello123}
ENV JENKINS_MASTER_URL=${JENKINS_MASTER_URL}
ENV JENKINS_SLAVE_NAME=${JENKINS_SLAVE_NAME}
ENV JENKINS_SLAVE_SECRET=${JENKINS_SLAVE_SECRET}
ENV JENKINS_SLAVE_WORKDIR=${JENKINS_SLAVE_WORKDIR}
ENV JENKINS_VERSION ${JENKINS_VERSION}
ENV JENKINS_UC https://updates.jenkins.io
ENV JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

###############################################################################
#Install && Setting
###############################################################################
RUN apk add --no-cache git openssh-client curl unzip bash ttf-dejavu coreutils py-pip ansible subversion \
  && echo "mkdir -p ${JENKINS_HOME}" \
  && mkdir -p ${JENKINS_HOME} \
  && mkdir -p /usr/share/jenkins/ref/init.groovy.d  \
  && echo "################ docker client " \
  && curl -f -L -o docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
  && tar xf docker.tgz \
  && mv docker/docker /usr/local/bin/docker \
  && chmod a+x /usr/local/bin/docker \
  && rm -rf docker \
  && rm docker.tgz \
  && echo "################ kubectl client " \
  && curl -f -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VER/bin/linux/amd64/kubectl \
  && chmod a+x /usr/local/bin/kubectl \
  && echo "################ tini           " \
  && curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini \
  && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha256sum -c - \
  && echo "################ jenkins master" \
  && curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha256sum -c - \
  && echo "################ jenkins slave" \
  && curl -f -L -o /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${JENKINS_SLAVE_VER}/remoting-${JENKINS_SLAVE_VER}.jar \
  && echo "################ maven         " \
  && curl -f -L -o apache-maven-$MAVEN_VER-bin.tar.gz https://apache.mirror.cdnetworks.com/maven/maven-3/$MAVEN_VER/binaries/apache-maven-$MAVEN_VER-bin.tar.gz \
  && tar xf apache-maven-$MAVEN_VER-bin.tar.gz \
  && mv apache-maven-$MAVEN_VER $MAVEN_HOME \
  && rm apache-maven-$MAVEN_VER-bin.tar.gz \
  && echo "################ sonar-scanner  " \
  && curl -f -L -o sonar-scanner-$SONAR_SCANNER_VER.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONAR_SCANNER_VER}.zip \
  && unzip sonar-scanner-$SONAR_SCANNER_VER.zip   >/dev/null 2>&1 \
  && mv sonar-scanner-$SONAR_SCANNER_VER $SONAR_HOME \
  && rm sonar-scanner-$SONAR_SCANNER_VER.zip \
  && echo "################ robot framework" \
  && pip install --no-cache-dir --upgrade pip; pip install --no-cache-dir robotframework robotframework-selenium2library\
  && ln -s /usr/local/share/maven/bin/mvn /usr/local/bin/mvn \
  && ln -s /usr/local/share/sonar/bin/sonar-scanner /usr/local/bin/sonar-scanner \
  && mkdir -p /data/jenkins  \
  && mkdir -p /data/maven    \
  && mkdir -p /data/kube     \
  && mkdir -p /data/sonar    \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*.apk

###############################################################################
#Prepare Setting
###############################################################################
COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy
COPY init_login.groovy /usr/share/jenkins/ref/init.groovy.d/set-user-security.groovy
COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

###############################################################################
#Install plugins
###############################################################################
#RUN /usr/local/bin/install-plugins.sh gitlab-plugin sonar redmine docker-build-step ansible build-pipeline-plugin buildgraph-view workflow-aggregator pipeline-maven pipeline-utility-steps ssh-slaves
RUN /usr/local/bin/install-plugins.sh gitlab-plugin ansible sonar redmine docker-build-step docker-workflow blueocean

###############################################################################
#Volume Setting
###############################################################################
VOLUME ["/usr/share/jenkins/", "/data/jenkins", "/data/maven", "/data/kube", "/data/sonar", "/data/robot"]

###############################################################################
#expose Setting
###############################################################################
# for main web interface:
EXPOSE ${http_port}
# will be used by attached slave agents:
EXPOSE ${agent_port}

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]
