FROM registry.access.redhat.com/rhel7/rhel:latest
ENV PATH /usr/sbin:/usr/bin
VOLUME ["/foo", "/foo/bar", "/usr/local/lib/baz"]