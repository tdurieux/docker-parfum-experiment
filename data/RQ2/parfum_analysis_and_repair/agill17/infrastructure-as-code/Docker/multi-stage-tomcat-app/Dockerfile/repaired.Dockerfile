###################################################
### Maven the builder
###################################################

FROM maven:latest as build

ARG repo=null

#FROM tomcat:latest as build
#RUN apt-get update  -y
#WORKDIR /opt
#ADD http://apache.mirrors.pair.com/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz .
#RUN apt-get install git openjdk-8-jdk -y \
#    && tar xzvf apache-maven-3.5.3-bin.tar.gz \
#    && rm -rf apache-maven-3.5.3-bin.tar.gz \
#ENV PATH="/opt/apache-maven-3.5.3/bin:${PATH}"

RUN mkdir /app

WORKDIR /app

RUN git clone $repo .

RUN if [ -d target ] ; then  rm -rf target; fi \
    && mvn package 


###################################################
## Final Prod level image
###################################################