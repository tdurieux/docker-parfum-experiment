# TODO: move to k8s.gcr.io/build-image/debian-base-ppc64le:bullseye-1.y.z when patched
FROM ppc64le/debian:bullseye-20220328

ADD etcd /usr/local/bin/
ADD etcdctl /usr/local/bin/
ADD etcdutl /usr/local/bin/
ADD var/etcd /var/etcd
ADD var/lib/etcd /var/lib/etcd

EXPOSE 2379 2380

# Define default command.