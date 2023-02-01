#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/kube-jenkins-dind-agent
MAINTAINER 若虚 <slpcat@qq.com>

USER root

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/home/jenkins"
ARG SHA512=c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0
#ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries