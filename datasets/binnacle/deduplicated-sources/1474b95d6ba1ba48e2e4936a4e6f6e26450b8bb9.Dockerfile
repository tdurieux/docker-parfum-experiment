FROM ubuntu:14.04
MAINTAINER Michael Neale <mneale@cloudbees.com

# First, let us install Jenkins - as per https://github.com/cloudbees/jenkins-docker
RUN echo "0.12" > .version
RUN apt-get update
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ >> /etc/apt/sources.list
RUN apt-get install -y wget
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN apt-get update
RUN apt-get install -y jenkins


# now we install docker in docker - thanks to https://github.com/jpetazzo/dind
RUN apt-get install -qqy iptables ca-certificates
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker
VOLUME /var/lib/docker

RUN apt-get install -y git

CMD wrapdocker && exec java -jar /usr/share/jenkins/jenkins.war
