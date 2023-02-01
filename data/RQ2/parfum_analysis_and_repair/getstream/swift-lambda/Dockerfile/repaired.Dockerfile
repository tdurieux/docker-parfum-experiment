FROM swift:5.3.1-amazonlinux2

RUN yum -y install zip && rm -rf /var/cache/yum
RUN yum -y install openssl-devel && rm -rf /var/cache/yum
