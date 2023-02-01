FROM registry.access.redhat.com/rhscl/nodejs-4-rhel7:latest
USER root
RUN yum install git -y && rm -rf /var/cache/yum
USER 1001
