# jdk8-centos7
FROM centos:latest

RUN yum -y update && yum clean all

# Set the labels that are used for OpenShift to describe the builder image.