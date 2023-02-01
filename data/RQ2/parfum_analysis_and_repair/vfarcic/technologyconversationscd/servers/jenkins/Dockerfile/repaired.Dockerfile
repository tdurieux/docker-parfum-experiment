FROM ubuntu:12.04
MAINTAINER Viktor Farcic, "viktor@farcic.com"

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe >> /etc/apt/sources.list
RUN apt-get update && apt-get clean
RUN apt-get install --no-install-recommends -q -y openjdk-7-jre-headless && apt-get clean && rm -rf /var/lib/apt/lists/*;
ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war /opt/jenkins.war
RUN ln -sf /jenkins /root/.jenkins

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
VOLUME ["/jenkins"]
CMD [""]
