FROM centos:7
RUN yum clean all && rm -rf /var/cache/yum || true && \
    yum -y install epel-release && \
    yum makecache all && rm -rf /var/cache/yum
RUN yum -y groups mark convert && \
    yum -y groups mark install "Development Tools" && \
    yum -y groups mark convert "Development Tools" && \
    yum -y groupinstall "Development Tools" && \
    yum -y install python2 rpm-build python-setuptools make bash which \
           python-pip python-devel && rm -rf /var/cache/yum
COPY . /src/vncpasswd.py
WORKDIR /src/vncpasswd.py
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["make bdist_rpm"]
