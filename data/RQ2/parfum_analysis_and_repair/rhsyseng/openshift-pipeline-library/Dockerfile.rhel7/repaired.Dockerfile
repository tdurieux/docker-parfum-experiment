FROM registry.access.redhat.com/rhel7

# This is just a temp example...
RUN yum install -y vim wget && rm -rf /var/cache/yum

CMD tail -f /dev/null
