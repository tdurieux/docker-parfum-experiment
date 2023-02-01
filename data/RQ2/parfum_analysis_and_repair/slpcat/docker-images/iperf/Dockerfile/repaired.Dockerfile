#upstream https://github.com/woqutech/docker-images
FROM centos
RUN yum -y install epel-release && rm -rf /var/cache/yum
RUN yum install -y iperf.x86_64 && rm -rf /var/cache/yum
