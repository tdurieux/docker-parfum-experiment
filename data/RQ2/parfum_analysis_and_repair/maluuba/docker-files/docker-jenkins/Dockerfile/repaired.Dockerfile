FROM ubuntu:14.04
MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

RUN apt-get update && apt-get clean
RUN apt-get install --no-install-recommends -qqy openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -qqy git docker.io && rm -rf /var/lib/apt/lists/*;

VOLUME /var/lib/docker

# Install Jenkins
ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war /opt/jenkins.war
ADD start-jenkins.sh /opt/start-jenkins.sh
RUN chmod +x /opt/start-jenkins.sh
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins
ENV LANG C.UTF-8

EXPOSE 8080

CMD ["/opt/start-jenkins.sh"]

