FROM diamol/base AS download
ARG JENKINS_VERSION="2.190.2"
RUN wget -O jenkins.war https://mirrors.jenkins.io/war-stable/${JENKINS_VERSION}/jenkins.war

FROM diamol/base
ENV JENKINS_HOME="/data"
EXPOSE 8080
ENTRYPOINT java -Duser.home=${JENKINS_HOME} -Djenkins.install.runSetupWizard=false -jar /jenkins/jenkins.war
COPY --from=download jenkins.war /jenkins/jenkins.war
COPY ./jenkins.install.UpgradeWizard.state ${JENKINS_HOME}/