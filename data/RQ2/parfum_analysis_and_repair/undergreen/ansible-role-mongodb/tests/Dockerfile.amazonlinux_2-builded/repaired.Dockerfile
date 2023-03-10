FROM amazonlinux:2

# This is needed so that ansible managed to read "ansible_default_ipv4"
# This step is needed since standard CentOS docker image does not come with i
# This package seems to be required for Mongo 3.2 and downwards
RUN yum install iproute initscripts python-pip python-devel -y && rm -rf /var/cache/yum

# we can has SSH
EXPOSE 22

# pepare for takeoff
CMD ["/usr/sbin/init"]
