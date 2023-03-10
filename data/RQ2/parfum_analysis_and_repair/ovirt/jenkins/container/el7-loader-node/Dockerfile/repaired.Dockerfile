FROM openshift/jenkins-slave-base-centos7

RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y git python-pyxdg python-six python-yaml python-jinja2 \
    python-py python-paramiko pytest python-mock python-requests && rm -rf /var/cache/yum