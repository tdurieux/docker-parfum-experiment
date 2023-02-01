# Jenkins slave with config
#
# VERSION               0.0.1

FROM       nuxeo/jenkins-slave-base
MAINTAINER Nuxeo Packagers <packagers@nuxeo.com>


RUN echo "\njenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Using intermediary dirs to work around Docker bug #1295