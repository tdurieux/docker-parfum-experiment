FROM registry.access.redhat.com/ubi8-minimal

ADD bin/talisman /usr/local/bin

ENTRYPOINT ["/usr/local/bin/talisman"]