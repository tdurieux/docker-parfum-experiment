# TODO: move to k8s.gcr.io/build-image/debian-base-s390x:bullseye-1.y.z when patched
FROM s390x/debian:bullseye-20220328

ADD etcd /usr/local/bin/
ADD etcdctl /usr/local/bin/
ADD etcdutl /usr/local/bin/
ADD var/etcd /var/etcd
ADD var/lib/etcd /var/lib/etcd

EXPOSE 2379 2380

# Define default command.