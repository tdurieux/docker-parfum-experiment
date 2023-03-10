ARG JENKINS_VER=2.277.1
ARG RELEASE=1

FROM target/jenkins-docker-master:${JENKINS_VER}-${RELEASE}
COPY files/debug_logs.groovy /usr/share/jenkins/ref/init.groovy.d/debug_logs.groovy
COPY files/debug_logging.properties /usr/share/jenkins/debug_logging.properties