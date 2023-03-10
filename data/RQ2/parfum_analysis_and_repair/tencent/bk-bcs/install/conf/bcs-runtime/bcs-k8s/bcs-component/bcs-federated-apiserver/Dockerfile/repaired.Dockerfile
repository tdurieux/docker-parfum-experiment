FROM centos:7
RUN yum install -y ca-certificates && rm -rf /var/cache/yum
ENV TZ Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone
ADD apiserver /usr/bin
CMD ["/usr/bin/apiserver"]