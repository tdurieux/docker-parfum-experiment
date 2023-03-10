FROM centos:7

# install required packages
RUN yum install -y epel-release \
    && yum update -y \
    && yum install -y  ansible && rm -rf /var/cache/yum

# install containernet (using its Ansible playbook)
COPY . /containernet
WORKDIR /containernet/ansible
RUN ansible-playbook -i "localhost," -c local --skip-tags "notindocker" install_centos.yml
WORKDIR /containernet
RUN python3 setup.py develop

# Hotfix: https://github.com/pytest-dev/pytest/issues/4770
RUN pip3 install --no-cache-dir "more-itertools<=5.0.0"

# tell containernet that it runs in a container
ENV CONTAINERNET_NESTED 1

# Important: This entrypoint is required to start the Docker and OVS service
ENTRYPOINT ["util/docker/entrypoint_centos.sh"]
CMD ["python3", "examples/containernet_example.py"]
