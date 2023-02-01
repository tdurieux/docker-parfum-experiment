#
# Before building this Dockerfile, BlueOcean needs to be built locally using Maven
# You can build everything needed and this Dockerfile by invoking `bin/build-in-docker.sh -m`
#

# Should be kept in sync with jenkins.properties of pom.xml
# Patch version is not to be considered, we prefer to base the image off the latest LTS of the line
# and keep the dependency on the baseline in pom.xml
FROM jenkins/jenkins-experimental:latest-jdk10

USER root

COPY blueocean/target/plugins /usr/share/jenkins/ref/plugins/

RUN for f in /usr/share/jenkins/ref/plugins/*.hpi; do mv "$f" "${f%%hpi}jpi"; done
RUN install-plugins.sh antisamy-markup-formatter matrix-auth # for security, you know
# https://github.com/jenkinsci/workflow-support-plugin/tree/java10-support
RUN install-plugins.sh "workflow-support:incrementals;org.jenkins-ci.plugins.workflow;2.19-rc295.e017dc58c0a3"

# Force use of locally built blueocean plugin
RUN for f in /usr/share/jenkins/ref/plugins/blueocean-*.jpi; do mv "$f" "$f.override"; done

# let scripts customize the reference Jenkins folder. Used in bin/build-in-docker to inject the git build data
COPY docker/ref /usr/share/jenkins/ref

USER jenkins
