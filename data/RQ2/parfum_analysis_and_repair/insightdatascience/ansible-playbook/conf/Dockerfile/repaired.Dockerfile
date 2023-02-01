########################################################
# Dockerfile for ansible-playbook
# Based on debian
########################################################

FROM ubuntu

MAINTAINER Ronak Nathani

RUN apt-get update \
	&& apt-get install --no-install-recommends -y software-properties-common \
	&& apt-add-repository ppa:ansible/ansible \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y ansible \
	&& apt-get install --no-install-recommends -y python-pip \
	&& apt-get install --no-install-recommends -y vim \
    && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir boto

COPY . /root/ansible-playbook

RUN rm /etc/ansible/hosts
RUN mkdir /etc/ansible/hosts/

COPY ansible_example.cfg /etc/ansible/ansible.cfg
COPY ec2.py /etc/ansible/hosts/
COPY ec2.ini /etc/ansible/hosts/
