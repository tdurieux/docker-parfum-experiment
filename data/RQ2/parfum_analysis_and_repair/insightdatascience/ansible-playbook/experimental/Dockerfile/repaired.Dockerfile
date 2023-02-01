########################################################
# Dockerfile for ansible-playbook
# Based on debian
########################################################

FROM debian:jessie

MAINTAINER Ronak Nathani

RUN apt-get update \
#	&& apt-get install -y software-properties-common \
#	&& apt-add-repository ppa:ansible/ansible \
#	&& apt-get update \
#	&& apt-get install -y ansible \
#	&& apt-get install -y python-pip \
#	&& apt-get install -y vim \
#    && apt-get install -y git