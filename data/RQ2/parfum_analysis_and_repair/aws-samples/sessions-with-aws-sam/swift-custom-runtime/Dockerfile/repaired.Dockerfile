FROM swift:5.2-amazonlinux2

RUN yum -y install zip openssl-devel && rm -rf /var/cache/yum
