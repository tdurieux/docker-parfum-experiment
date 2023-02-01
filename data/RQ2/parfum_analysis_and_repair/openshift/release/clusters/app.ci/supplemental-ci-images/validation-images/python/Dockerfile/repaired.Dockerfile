FROM centos:8

RUN yum update -y; yum install -y python38 python38-pip; rm -rf /var/cache/yum yum clean all

RUN pip3 install --no-cache-dir pyyaml
RUN pip3 install --no-cache-dir ruamel.yaml
RUN pip3 install --no-cache-dir pylint
