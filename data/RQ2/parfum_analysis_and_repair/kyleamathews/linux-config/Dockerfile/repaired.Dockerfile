FROM ubuntu:14.04
MAINTAINER Kyle Mathews "mathews.kyle@gmail.com"

RUN apt-get update; apt-get install --no-install-recommends -y python-software-properties software-properties-common; rm -rf /var/lib/apt/lists/*; apt-add-repository ppa:ansible/ansible;
RUN apt-get update
RUN apt-get install --no-install-recommends ansible -y && rm -rf /var/lib/apt/lists/*;
ADD . /opt/config
WORKDIR /opt/config
RUN echo "localhost	ansible_connection=local" >> ~/.ansible_hosts
RUN ansible-playbook dev.yml -i ~/.ansible_hosts -v
