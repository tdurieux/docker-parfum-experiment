FROM centos:7.6.1810

ADD kubernetes.repo /etc/yum.repos.d/kubernetes.repo

RUN yum clean all && yum update -y && yum install -y kubectl && rm -rf /var/cache/yum

RUN mkdir -p /out

RUN cp /usr/bin/kubectl /out/kubectl
