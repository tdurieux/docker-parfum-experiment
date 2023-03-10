FROM centos/systemd:latest

RUN yum makecache fast && yum update -y && \
    yum install -y python sudo yum-plugin-ovl && \
    sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && rm -rf /var/cache/yum
