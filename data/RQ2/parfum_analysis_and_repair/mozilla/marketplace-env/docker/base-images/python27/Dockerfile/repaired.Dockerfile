FROM centos:centos6

ADD yum/mkt.repo /etc/yum.repos.d/mkt.repo

RUN yum install -y python27 git gcc && yum clean all && rm -rf /var/cache/yum
RUN yum install -y python27-m2crypto python27-python-lxml libxslt && yum clean all && rm -rf /var/cache/yum

ENV PATH /opt/rh/python27/root/usr/bin:$PATH
ENV LD_LIBRARY_PATH /opt/rh/python27/root/usr/lib64
ENV LANG en_US.UTF-8

# Peep won't work with pip 7 yet.
RUN easy_install pip==6.1.1
RUN pip install --no-cache-dir ipython ipdb
