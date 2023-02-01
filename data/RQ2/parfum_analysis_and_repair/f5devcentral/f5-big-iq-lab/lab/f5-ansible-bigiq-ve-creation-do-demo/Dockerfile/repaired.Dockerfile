FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3 python3-dev python3-pip python3-jmespath && \
    apt-get install --no-install-recommends -y openssh-client iputils-ping sshpass wget && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install --no-cache-dir ansible

COPY ansible.cfg /etc/ansible/ansible.cfg

RUN mkdir -p /usr/share/ansible/roles
RUN mkdir -p /etc/ansible/roles

RUN ansible-galaxy install f5devcentral.bigiq_onboard,master
RUN ansible-galaxy install f5devcentral.register_dcd,master
RUN ansible-galaxy install f5devcentral.atc_deploy --force
RUN ansible-galaxy install f5devcentral.bigiq_pinning_deploy_objects --force
RUN ansible-galaxy install f5devcentral.bigiq_move_app_dashboard --force
RUN ansible-galaxy install f5devcentral.bigiq_create_ve --force

RUN ansible-galaxy collection install f5networks.f5_modules --force