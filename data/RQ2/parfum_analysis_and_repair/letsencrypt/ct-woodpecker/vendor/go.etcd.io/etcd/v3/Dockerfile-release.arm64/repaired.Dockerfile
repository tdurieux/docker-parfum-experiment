# TODO: move to k8s.gcr.io/build-image/debian-base-arm64:bullseye-1.y.z when patched
FROM arm64v8/debian:bullseye-20220328

ADD etcd /usr/local/bin/
ADD etcdctl /usr/local/bin/
ADD etcdutl /usr/local/bin/
ADD var/etcd /var/etcd
ADD var/lib/etcd /var/lib/etcd
ENV ETCD_UNSUPPORTED_ARCH=arm64

EXPOSE 2379 2380

# Define default command.