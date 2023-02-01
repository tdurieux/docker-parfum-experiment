FROM centos:7

RUN yum -y install wget && \
    wget https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh && \
    chmod +x *.sh && ./script.rpm.sh && rm -rf /var/cache/yum

RUN yum -y install sensu-go-agent && rm -rf /var/cache/yum
