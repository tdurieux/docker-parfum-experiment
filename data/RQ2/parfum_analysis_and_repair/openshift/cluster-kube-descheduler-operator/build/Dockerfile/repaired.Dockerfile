FROM alpine:3.6

USER nobody

ADD build/_output/bin/cluster-kube-descheduler-operator /usr/local/bin/cluster-kube-descheduler-operator