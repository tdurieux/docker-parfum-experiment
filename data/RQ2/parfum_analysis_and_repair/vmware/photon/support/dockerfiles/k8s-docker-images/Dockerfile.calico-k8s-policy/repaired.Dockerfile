FROM k8s-base-image:4.0

ADD tmp/calico/usr/bin/controller /dist/

ENTRYPOINT ["/dist/controller"]