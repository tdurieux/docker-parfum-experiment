FROM centos

USER root

RUN yum -y update && yum -y install epel-release && rm -rf /var/cache/yum
RUN yum -y update && yum -y install vim python python-pip git && rm -rf /var/cache/yum

COPY . /work
WORKDIR /work
RUN pip install --no-cache-dir -r automated/utils/requirements.txt

CMD . ./automated/bin/setenv.sh && test-runner -p plans/linux-example.yaml && bash

