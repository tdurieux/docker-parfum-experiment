FROM openresty/openresty:centos

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-* &&\
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*

# netcat is used to listen to the ports.

RUN yum install -y nmap-ncat && rm -rf /var/cache/yum
