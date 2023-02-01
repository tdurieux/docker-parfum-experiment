RUN yum install -y gcc gcc-c++ && \
    yum install -y python3-devel && \
    yum clean all && rm -rf /var/cache/yum
