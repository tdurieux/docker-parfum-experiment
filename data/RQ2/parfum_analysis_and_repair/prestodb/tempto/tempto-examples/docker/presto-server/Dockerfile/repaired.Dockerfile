FROM prestodb/centos6-oj8
MAINTAINER Presto community <https://prestodb.io/community.html>

RUN yum install -y tar && rm -rf /var/cache/yum

RUN curl -f -SL https://search.maven.org/remotecontent?filepath=com/facebook/presto/presto-server/0.181/presto-server-0.181.tar.gz \
      | tar xz \
      && mv $(find -type d -name 'presto-server*') presto-server

RUN mkdir /presto-server/etc

COPY etc /presto-server/etc/

CMD /presto-server/bin/launcher run
