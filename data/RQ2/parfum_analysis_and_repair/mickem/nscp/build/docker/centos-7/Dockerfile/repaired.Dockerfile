FROM centos:7

RUN mkdir /nscp
ADD . /nscp/

RUN yum update -y epel-release
RUN yum install -y cmake python-devel openssl-devel boost-devel lua-devel redhat-lsb rpmdevtools && rm -rf /var/cache/yum
RUN yum groupinstall -y 'Development Tools'
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install --enablerepo=epel -y gtest-devel python-argparse.noarch && rm -rf /var/cache/yum
RUN yum install -y protobuf-devel protobuf-compiler protobuf-python cryptopp-devel python-pip && rm -rf /var/cache/yum

ENV GH_TOKEN=UPDATE_ME

# Workaround for python and outdated ssl libs
#RUN yum install -y libffi-devel
#RUN pip install urllib3[secure]


RUN pip install --no-cache-dir jinja2 mkdocs mkdocs-material github3.py

RUN mkdir -p /build
RUN mkdir -p /packages

VOLUME /packages

CMD /src/nscp/build/sh/build-centos.sh

