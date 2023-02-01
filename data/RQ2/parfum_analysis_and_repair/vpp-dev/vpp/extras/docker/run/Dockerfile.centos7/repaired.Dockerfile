FROM centos:7.3.1611
ARG REPO=release
RUN curl -f -s https://packagecloud.io/install/repositories/fdio/${REPO}/script.rpm.sh | bash
RUN yum -y install vpp vpp-plugins && rm -rf /var/cache/yum
CMD ["/usr/bin/vpp","-c","/etc/vpp/startup.conf"]