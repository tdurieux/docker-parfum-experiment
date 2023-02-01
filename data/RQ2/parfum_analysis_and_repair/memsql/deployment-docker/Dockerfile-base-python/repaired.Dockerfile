ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# updates and basic utilities
ARG RELEASE_CHANNEL=production
RUN yum install -y mysql-devel gcc && rm -rf /var/cache/yum

#install python39 where it is supported
RUN yum install python39 python3-devel -y && pip3 install --no-cache-dir --upgrade pip && pip3 install --no-cache-dir mysqlclient && update-alternatives --set python /usr/bin/python3; rm -rf /var/cache/yumif [ $? -ne 0 ]; then \
 wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-runtime-2.0-1.el7.x86_64.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-python-pip-9.0.1-5.el7.noarch.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-python-3.6.12-1.el7.x86_64.rpm && \
    wget https://mirror.centos.org/altarch/7/sclo/aarch64/rh/Packages/r/rh-python36-python-setuptools-36.5.0-1.el7.noarch.rpm && \
    wget https://mirror.centos.org/centos/7/sclo/x86_64/rh/Packages/r/rh-python36-python-libs-3.6.12-1.el7.x86_64.rpm && \
    yum install -y epel-release-latest-7.noarch.rpm rh-python36-runtime-2.0-1.el7.x86_64.rpm rh-python36-python-pip-9.0.1-5.el7.noarch.rpm rh-python36-python-3.6.12-1.el7.x86_64.rpm rh-python36-python-setuptools-36.5.0-1.el7.noarch.rpm rh-python36-python-libs-3.6.12-1.el7.x86_64.rpm; \
    echo '/opt/rh/rh-python36/root/usr/lib64/' >> /etc/ld.so.conf && ldconfig; \
    ln -s /opt/rh/rh-python36/root/usr/bin/python3 /usr/bin/python3; \
    /usr/bin/python3 -m pip install --upgrade pip; \
    /usr/bin/python3 -m pip install pymysql; \
fi

RUN yum clean all

