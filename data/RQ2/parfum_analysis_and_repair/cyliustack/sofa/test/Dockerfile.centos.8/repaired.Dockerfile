FROM centos:8
RUN yum update -y
RUN yum install git wget curl vim python3 -y && rm -rf /var/cache/yum
COPY sofaroot/tools/prepare.sh prepare.sh
RUN ./prepare.sh
COPY sofaroot /sofaroot
