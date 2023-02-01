FROM swift:5.5-amazonlinux2

RUN yum -y install zip && rm -rf /var/cache/yum
