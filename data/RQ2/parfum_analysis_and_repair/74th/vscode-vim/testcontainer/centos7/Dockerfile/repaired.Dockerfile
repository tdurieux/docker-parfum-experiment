FROM centos:7

RUN curl -f --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs vim && rm -rf /var/cache/yum