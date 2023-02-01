FROM centos:6.6

# has curl in base image
RUN yum -y install wget tar rsync \
&& yum clean all && rm -rf /var/cache/yum

CMD ["/bin/bash"]
