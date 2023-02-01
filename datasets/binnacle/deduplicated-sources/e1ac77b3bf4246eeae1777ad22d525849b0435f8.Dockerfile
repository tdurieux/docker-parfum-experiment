FROM fedora:latest
LABEL maintainer="Sebastian Gumprich"

RUN dnf -y update \
    && dnf -y install ansible python libselinux-python \
    && dnf clean all

RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD [ "ansible-playbook", "--version" ]
