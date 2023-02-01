FROM stackbrew/ubuntu:16.04
MAINTAINER Gerard Paligot "gerard.paligot@inria.fr"

RUN apt-get update && apt-get clean

# Set the locale
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8

# Install package use by jenkins and these plugins.
RUN apt-get install --no-install-recommends -y manpages manpages-dev freebsd-manpages funny-manpages gmt-manpages man2html asr-manpages && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y bc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xmlstarlet && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Install Java 7 and Java 8 and maven which needs Java.
RUN apt-get update && apt-get clean
RUN apt-get install --no-install-recommends -y openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -q -y openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"\
    > /etc/apt/sources.list.d/webupd8team-java.list \
    && echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main"\
    >> /etc/apt/sources.list.d/webupd8team-java.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 \
    && apt-get update -y \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections \
    && apt-get install -y --no-install-recommends oracle-java8-installer \
    && apt-get autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/oracle-jdk8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

# Install Jenkins.
RUN wget -q -O - https://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y jenkins && rm -rf /var/lib/apt/lists/*;
ENV JENKINS_HOME /var/lib/jenkins

# Install processors project.
RUN cd /root && git clone https://github.com/GerardPaligot/spoon-processors.git
RUN cd /root/spoon-processors && mvn clean install

ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
EXPOSE 8080
VOLUME "/Users/gerard/Documents/jenkins"
CMD [""]