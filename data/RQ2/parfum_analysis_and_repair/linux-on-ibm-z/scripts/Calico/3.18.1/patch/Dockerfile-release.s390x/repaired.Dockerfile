FROM k8s.gcr.io/debian-base-s390x:v1.0.0

ENV ETCD_UNSUPPORTED_ARCH=s390x
ADD etcd /usr/local/bin/
ADD etcdctl /usr/local/bin/
ADD var/etcd /var/etcd
ADD var/lib/etcd /var/lib/etcd

EXPOSE 2379 2380

# Define default command.
CMD ["/usr/local/bin/etcd"]