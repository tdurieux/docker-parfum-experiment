FROM ubuntu:precise
MAINTAINER Casimir Saternos

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN apt-get update
run apt-get -y --no-install-recommends install python && rm -rf /var/lib/apt/lists/*;
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y --no-install-recommends install oracle-java7-installer && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --display java
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/environment
RUN wget https://repo2.maven.org/maven2/org/mortbay/jetty/jetty-runner/8.1.9.v20130131/jetty-runner-8.1.9.v20130131.jar
RUN wget https://web-actions.googlecode.com/files/helloworld.war
RUN java -jar jetty-runner-8.1.9.v20130131.jar helloworld.war