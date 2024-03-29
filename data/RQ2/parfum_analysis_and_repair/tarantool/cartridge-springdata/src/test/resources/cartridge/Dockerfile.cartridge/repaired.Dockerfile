# Simple Dockerfile
# Used by `pack docker` command as a base for runtime image

# The base image must be centos:8
FROM centos:8

# Here you can install some packages required
#   for your application in runtime
#
# For example, if you need to install some python packages,
#   you can do it this way:
#
# COPY requirements.txt /tmp
# RUN yum install -y python3-pip
# RUN pip3 install -r /tmp/requirements.txt