FROM registry.access.redhat.com/ubi8:latest

RUN dnf install -y --nodocs git python3 python3-pip gcc python3-devel gcc-c++ atlas-devel gcc-gfortran  && dnf clean all
COPY snafu/image_resources/centos8-appstream.repo /etc/yum.repos.d/centos8-appstream.repo
RUN dnf install -y --nodocs redis --enablerepo=centos8-appstream && dnf clean all
RUN dnf install -y --nodocs hostname procps-ng iproute net-tools ethtool nmap iputils https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && dnf clean all
RUN dnf install -y uperf && dnf clean all
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN python3 -m pip install --upgrade cython numpy importlib_metadata 'urllib3!=1.25.0,!=1.25.1,<1.26,>=1.21.1' && python3 -m pip install --upgrade scipy pandas
RUN mkdir -p /opt/snafu/
COPY . /opt/snafu/
RUN pip3 install --no-cache-dir -e /opt/snafu/
