FROM centos:7
RUN yum update -y
RUN yum -y install initscripts && rm -rf /var/cache/yum
RUN yum install -y sudo openssh-server openssh-clients which curl && rm -rf /var/cache/yum
RUN yum install -y net-tools tar && rm -rf /var/cache/yum
RUN curl -f -sSL https://www.opscode.com/chef/install.sh | sudo bash -s -- -v 12.19.36
