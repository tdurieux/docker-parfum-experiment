FROM ceph/demo

ENV MON_IP 0.0.0.0
ENV CEPH_PUBLIC_NETWORK 0.0.0.0/0

EXPOSE 5000