FROM k8s-base-image:4.0

ADD tmp/k8dns/usr/bin/kube-dns /kube-dns
ENTRYPOINT ["/kube-dns"]