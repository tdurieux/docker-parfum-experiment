FROM centos:7

# This is needed so that ansible managed to read "ansible_default_ipv4"
# This step is needed since standard CentOS docker image does not come with EPEL installed by default
RUN yum install iproute epel-release python-pip python-devel -y && rm -rf /var/cache/yum

# we can has SSH
EXPOSE 22

# pepare for takeoff
CMD ["/usr/sbin/init"]
