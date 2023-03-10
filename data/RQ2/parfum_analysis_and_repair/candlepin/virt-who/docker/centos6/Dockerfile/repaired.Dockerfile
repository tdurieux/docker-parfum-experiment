FROM centos:6
MAINTAINER Radek Novacek <rnovacek@redhat.com>
RUN yum install -y libvirt-python python-suds m2crypto python-requests epel-release && \
    curl -f -L https://copr.fedoraproject.org/coprs/dgoodwin/subscription-manager/repo/epel-6/dgoodwin-subscription-manager-epel-6.repo > /etc/yum.repos.d/dgoodwin-subscription-manager-epel-6.repo && \
    yum install -y python-pip python-rhsm && \
    pip install --no-cache-dir -U pytest-timeout mock unittest2 setuptools && \
    yum clean all && rm -rf /var/cache/yum
COPY . /virt-who
WORKDIR /virt-who
CMD PYTHONPATH=. py.test --timeout=30
