# Build the docker image using the local build in developer box
# To avoid downloading everything from the internet and using developer's cache

FROM openjdk:8-jdk
ENV JENKINS_UC https://updates.jenkins.io
ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/casc
USER root
RUN mkdir -p /app /usr/share/jenkins/ref/plugins /usr/share/jenkins/ref/casc
RUN echo "jenkins: {}" >/usr/share/jenkins/ref/casc/jenkins.yaml

COPY vanilla-package/target/appassembler /app
COPY packaging/docker/unix/jenkinsfile-runner-launcher /app/bin

VOLUME /usr/share/jenkins/ref/casc

# TODO: Cleanup once JFR can operate without options