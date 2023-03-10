FROM golang:1.10.1-alpine

ENV TEST_ASSET_DIR /usr/local/bin
ENV TEST_ASSET_KUBECTL $TEST_ASSET_DIR/kubectl
ENV TEST_ASSET_KUBE_APISERVER $TEST_ASSET_DIR/kube-apiserver
ENV TEST_ASSET_ETCD $TEST_ASSET_DIR/etcd

ENV TEST_ASSET_URL https://storage.googleapis.com/k8s-c10s-test-binaries

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -f -L ${TEST_ASSET_URL}/etcd-Linux-x86_64 --output $TEST_ASSET_ETCD \
 && curl -f -L ${TEST_ASSET_URL}/kube-apiserver-Linux-x86_64 --output $TEST_ASSET_KUBE_APISERVER \
 && curl -f -L https://storage.googleapis.com/kubernetes-release/release/v1.9.2/bin/linux/amd64/kubectl --output $TEST_ASSET_KUBECTL \
 && chmod +x $TEST_ASSET_ETCD $TEST_ASSET_KUBE_APISERVER $TEST_ASSET_KUBECTL \
 && apk del --purge deps \
 && rm /var/cache/apk/*
