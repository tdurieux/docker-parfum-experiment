FROM alisw/mesos-base:0.23.0-cc7

RUN yum update -y && yum -y install chronos && rm -rf /var/cache/yum

COPY run.sh /run.sh

CMD sh -ex /run.sh
