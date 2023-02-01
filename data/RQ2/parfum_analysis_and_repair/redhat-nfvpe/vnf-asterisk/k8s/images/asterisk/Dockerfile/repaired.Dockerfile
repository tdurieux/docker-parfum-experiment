FROM dougbtv/asterisk14
MAINTAINER @nfvpe

RUN yum install -y etcd && rm -rf /var/cache/yum
