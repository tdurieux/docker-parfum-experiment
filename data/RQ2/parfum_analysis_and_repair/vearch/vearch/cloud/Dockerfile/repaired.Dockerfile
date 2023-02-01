FROM centos:7

ADD compile/bin /vearch/bin/
ADD compile/lib /vearch/lib/

ENV MASTER_NAME="___MASTER_NAME___"
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/vearch/lib/"
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y libgomp lapack openssl libzstd openblas tbb && rm -rf /var/cache/yum

ENTRYPOINT ["/vearch/bin/vearch", "-conf", "/vearch/config.toml", "-master", "$MASTER_NAME"]
