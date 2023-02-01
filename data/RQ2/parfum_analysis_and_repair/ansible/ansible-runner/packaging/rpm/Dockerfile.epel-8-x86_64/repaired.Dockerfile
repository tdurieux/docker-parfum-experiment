FROM quay.io/centos/centos:stream8

RUN dnf install -y epel-release
RUN yum install -y make mock python3-pip which git gcc python3-devel && rm -rf /var/cache/yum
RUN pip3 install --no-cache-dir -IU pip >=21.0.1
RUN pip3 install --no-cache-dir -IU ansible

RUN sed -i 's/release=8/release=8-stream/g' /etc/mock/templates/centos-8.tpl
