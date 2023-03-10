# Simple Dockerfile
# Used by "pack" command as a base for build image
# when --use-docker option is specified
#
# Image based on centos:7 is expected to be used
FROM centos:7

# Here you can install some packages required
#   for your application build
#
# RUN set -x \
#    && curl -sL https://rpm.nodesource.com/setup_10.x | bash - \
#    && yum -y install nodejs