# Latest version of centos
FROM centos:centos7
MAINTAINER James Cuzella <james.cuzella@lyraphase.com>
RUN yum clean all && \
    yum -y install epel-release && \
    yum -y groupinstall "Development tools" && \
    yum -y install python-devel MySQL-python sshpass && \
    yum -y install acl sudo && \
    sed -i -e 's/^Defaults.*requiretty/Defaults    !requiretty/' -e 's/^%wheel.*ALL$/%wheel    ALL=(ALL)    NOPASSWD: ALL/' /etc/sudoers && \
    yum -y install python-pip && \
    pip install --no-cache-dir --upgrade "pip < 19.2" && \
    pip install --no-cache-dir requests[security] && \
    pip install --no-cache-dir pbr==1.1.0 oslo.serialization==1.6.0 oslo.utils==2.0.0 oslo.i18n==1.7.0 \
    debtcollector==0.5.0 python-keystoneclient==1.6.0 oslo.config==1.12.0 stevedore==1.5.0 && \
    pip install --no-cache-dir pyrax pysphere boto boto3 passlib dnspython && \
    yum -y remove $(rpm -qa "*-devel") && \
    yum -y groupremove "Development tools" && \
    yum -y autoremove && \
    yum -y install bzip2 crontabs file findutils gem git gzip hg procps-ng svn sudo tar tree which unzip xz zip && rm -rf /var/cache/yum

RUN mkdir /etc/ansible/
RUN echo -e '[local]\nlocalhost' > /etc/ansible/hosts
RUN pip install --no-cache-dir ansible

CMD ["/bin/bash"]
