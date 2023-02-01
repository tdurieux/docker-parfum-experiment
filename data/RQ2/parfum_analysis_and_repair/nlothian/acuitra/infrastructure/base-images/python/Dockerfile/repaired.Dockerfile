# Python base image
#
# VERSION 0.1



# Ubuntu 12.04
FROM ubuntu:precise
MAINTAINER Nick Lothian nick.lothian@gmail.com


RUN apt-get update

# Setup python
RUN apt-get -y --no-install-recommends install build-essential python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN easy_install pip
RUN pip install --no-cache-dir setuptools --no-use-wheel --upgrade

