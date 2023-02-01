# Dockerfile for building image that contains software stack provisioned by Ansible.
#
# Version  1.1
#


# pull base image
FROM williamyeh/ansible:centos7-onbuild

MAINTAINER William Yeh <william.pjyeh@gmail.com>


#
# build phase
#

ENV PLAYBOOK prefetch.yml
RUN ansible-playbook-wrapper



#
# output phase
#