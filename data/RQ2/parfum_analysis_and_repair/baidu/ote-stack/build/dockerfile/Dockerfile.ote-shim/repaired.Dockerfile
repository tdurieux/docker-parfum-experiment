FROM alpine

COPY k8s_cluster_shim /usr/local/bin/

WORKDIR /usr/local/bin/
ENTRYPOINT ["./k8s_cluster_shim"]