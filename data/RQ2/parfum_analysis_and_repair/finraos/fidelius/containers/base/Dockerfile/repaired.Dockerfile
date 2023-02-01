FROM amazonlinux:2
MAINTAINER Fidelius Contributors

RUN yum install -y openssl && rm -rf /var/cache/yum
RUN yum install -y dos2unix && rm -rf /var/cache/yum
ADD /scripts/selfsign.sh /tmp/selfsign.sh
RUN chmod a+rx /tmp/selfsign.sh
RUN dos2unix /tmp/selfsign.sh
RUN yum remove -y dos2unix
RUN /tmp/selfsign.sh

