FROM centos/systemd

RUN yum install iproute -y && rm -rf /var/cache/yum
RUN yum install sudo -y && rm -rf /var/cache/yum
RUN yum install python3 -y && rm -rf /var/cache/yum
RUN yum install ca-certificates -y && rm -rf /var/cache/yum
RUN yum install openssh-clients -y && rm -rf /var/cache/yum
RUN yum install openssl -y && rm -rf /var/cache/yum
RUN yum install openssh-server -y && rm -rf /var/cache/yum
RUN yum install which -y && rm -rf /var/cache/yum
