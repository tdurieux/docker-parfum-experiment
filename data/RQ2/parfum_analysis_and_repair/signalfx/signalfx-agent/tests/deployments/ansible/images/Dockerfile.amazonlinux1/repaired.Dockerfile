FROM amazonlinux:1

ENV container docker
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN yum install -y upstart procps initscripts python36-pip && rm -rf /var/cache/yum
RUN pip-3.6 install -U pip==20.3.4

ARG ANSIBLE_VERSION='==2.4.0'
RUN pip3 install --no-cache-dir ansible${ANSIBLE_VERSION}

VOLUME [ "/sys/fs/cgroup" ]

COPY deployments/ansible/* /opt/playbook/
COPY tests/deployments/ansible/images/inventory.ini /opt/playbook/
COPY tests/deployments/ansible/images/playbook.yml /opt/playbook/
COPY tests/packaging/images/init-fake.conf /etc/init/fake-container-events.conf

CMD ["/sbin/init"]
