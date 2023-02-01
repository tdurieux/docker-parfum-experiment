FROM centos:centos7
RUN yum install -y git-all && rm -rf /var/cache/yum
RUN yum install -y gcc gcc-c++ flex bison && rm -rf /var/cache/yum
RUN yum install -y make cmake && rm -rf /var/cache/yum
RUN yum install -y llvm-devel && rm -rf /var/cache/yum
RUN yum install -y boost-python boost-devel && rm -rf /var/cache/yum
RUN yum install -y sip-devel && rm -rf /var/cache/yum
USER nobody
