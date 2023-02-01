FROM ubuntu:12.04
MAINTAINER Viktor Farcic, "viktor@farcic.com"

# General
RUN echo deb http://archive.ubuntu.com/ubuntu precise universe >> /etc/apt/sources.list
RUN apt-get update && apt-get clean
RUN apt-get install --no-install-recommends -q -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y unzip && rm -rf /var/lib/apt/lists/*;

# JDK
RUN apt-get install --no-install-recommends -q -y openjdk-7-jdk && apt-get clean && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# GIT
RUN apt-get install --no-install-recommends -q -y git && rm -rf /var/lib/apt/lists/*;

# Gradle
ADD https://services.gradle.org/distributions/gradle-1.12-all.zip /opt/gradle-1.12-all.zip
RUN unzip /opt/gradle-1.12-all.zip -d /opt/
ENV GRADLE_HOME /opt/gradle-1.12
ENV PATH $PATH:$GRADLE_HOME/bin

# Jenkins
ADD http://mirrors.jenkins-ci.org/war/latest/jenkins.war /opt/jenkins.war
RUN ln -sf /jenkins /root/.jenkins


ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080
VOLUME ["/jenkins"]
CMD [""]
